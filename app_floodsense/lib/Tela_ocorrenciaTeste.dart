import 'dart:convert';
import 'dart:io'; // Necessário para exibir a foto tirada usando Image.file
import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // Pacote da câmera

const _blue = Color(0xFF0754A5);
const _brightBlue = Color(0xFF168EE5);
const _paleBlue = Color(0xFFE8F7FF);
const _orange = Color(0xFFFF861D);

class OccurrenceApp extends StatelessWidget {
  const OccurrenceApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'FloodSense',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: _blue, primary: _blue),
      scaffoldBackgroundColor: _paleBlue,
      useMaterial3: true,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD7E7F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD7E7F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _blue, width: 1.5),
        ),
      ),
    ),
    home: const OccurrenceFormPage(),
  );
}

class OccurrenceFormPage extends StatefulWidget {
  const OccurrenceFormPage({super.key});

  @override
  State<OccurrenceFormPage> createState() => _OccurrenceFormPageState();
}

class _OccurrenceFormPageState extends State<OccurrenceFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  
  // Força o horário exato de Brasília (UTC-3), independente do fuso do celular
  DateTime _occurredAt = DateTime.now().toUtc().subtract(const Duration(hours: 3));

  // Variáveis para a Câmera
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  XFile? _capturedImage; // Armazena a foto tirada
  bool _isPhotoConfirmed = false; // Controla se o usuário aceitou a foto

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  // Inicializa o acesso à câmera nativa
  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      // Pegamos a primeira câmera disponível (geralmente a traseira)
      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false, // Não precisamos de áudio para fotos
      );

      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Erro ao inicializar a câmera: $e');
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    _cameraController?.dispose(); // Sempre liberar a câmera ao fechar a tela
    super.dispose();
  }

  String get _date => '${_two(_occurredAt.day)}/${_two(_occurredAt.month)}/${_occurredAt.year}';
  String get _time => '${_two(_occurredAt.hour)}:${_two(_occurredAt.minute)}';
  String _two(int value) => value.toString().padLeft(2, '0');

  Future<void> _pickDate() async {
    final value = await showDatePicker(
      context: context,
      initialDate: _occurredAt,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (value == null) return;
    setState(() {
      _occurredAt = DateTime(
        value.year, value.month, value.day, 
        _occurredAt.hour, _occurredAt.minute,
      );
    });
  }

  Future<void> _pickTime() async {
    final value = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_occurredAt),
    );
    if (value == null) return;
    setState(() {
      _occurredAt = DateTime(
        _occurredAt.year, _occurredAt.month, _occurredAt.day, 
        value.hour, value.minute,
      );
    });
  }

  // Função para capturar a foto
  Future<void> _takePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    
    try {
      final XFile photo = await _cameraController!.takePicture();
      setState(() {
        _capturedImage = photo;
        _isPhotoConfirmed = false; // Entra no modo de revisão da foto
      });
    } catch (e) {
      debugPrint('Erro ao tirar foto: $e');
    }
  }

  // Função para descartar a foto e abrir a câmera novamente
  void _retakePhoto() {
    setState(() {
      _capturedImage = null;
      _isPhotoConfirmed = false;
    });
  }

  // Função para confirmar o uso da foto capturada
  void _confirmPhoto() {
    setState(() {
      _isPhotoConfirmed = true;
    });
  }

  // Função pronta para integrar o pacote geolocator no futuro
  Future<void> _getCurrentLocation() async {
    // TODO: Adicionar o pacote geolocator no pubspec.yaml e implementar a busca real de lat/long.
    // Exemplo: Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _locationController.text = "Buscando localização atual...";
      // Simulação rápida para feedback visual
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          _locationController.text = "Av. Paulista, 1578 - São Paulo, SP"; // Exemplo
        }
      });
    });
  }

  // Preparação estruturada para enviar os dados ao Supabase
  Future<void> _prepareSubmission() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Validação extra: garantir que uma foto foi confirmada
    if (_capturedImage == null || !_isPhotoConfirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, tire e confirme uma foto antes de enviar.')),
      );
      return;
    }

    // Ambiente pronto para enviar ao Supabase
    final payload = {
      'descricao': _descriptionController.text.trim(),
      'localizacao': _locationController.text.trim(),
      'dataHora': _occurredAt.toIso8601String(), // Já está no fuso UTC-3 (Brasília)
      // O path local será usado para fazer upload no Supabase Storage primeiro.
      // Depois do upload, você trocará isso pela URL gerada pelo Supabase.
      'foto_caminho_local': _capturedImage!.path, 
    };
    
    final json = const JsonEncoder.withIndent('  ').convert(payload);

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dados prontos para o Supabase'),
        content: SingleChildScrollView(
          child: SelectableText(
            json,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _paleBlue,
    appBar: AppBar(
      backgroundColor: _paleBlue,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.water_drop_rounded, color: _brightBlue, size: 22),
          SizedBox(width: 8),
          Text(
            'FloodSense',
            style: TextStyle(color: _blue, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    ),
    body: SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: _orange,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.report_outlined, color: Colors.white, size: 30),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Registrar ocorrência',
                              style: TextStyle(
                                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Conte o que aconteceu e onde.',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(240), // withValues(alpha) -> withAlpha (240 = 94%)
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel('Foto da ocorrência'),
                      const SizedBox(height: 8),
                      
                      // AREA DA CÂMERA COM PROPORÇÃO 9:16
                      Center(
                        child: SizedBox(
                          height: 380, // Altura limite para não ocupar a tela toda
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: AspectRatio(
                              aspectRatio: 9 / 16, // Proporção exata pedida
                              child: Container(
                                color: Colors.black,
                                child: _buildCameraContent(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      _sectionLabel('Descrição'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descriptionController,
                        minLines: 4,
                        maxLines: 7,
                        maxLength: 1000,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText: 'Descreva o que aconteceu',
                          alignLabelWithHint: true,
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Informe a descrição da ocorrência.'
                            : null,
                      ),
                      
                      const SizedBox(height: 16),
                      _sectionLabel('Localização'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _locationController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Digite o endereço ou uma referência',
                          prefixIcon: const Icon(Icons.location_on_outlined),
                          // Botão no canto direito do input para ativar o GPS
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.my_location, color: _brightBlue),
                            tooltip: 'Pegar localização atual',
                            onPressed: _getCurrentLocation, 
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Informe a localização da ocorrência.'
                            : null,
                      ),
                      
                      const SizedBox(height: 16),
                      _sectionLabel('Data e hora'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _dateTimeButton(_date, Icons.calendar_today_outlined, _pickDate),
                          const SizedBox(width: 10),
                          _dateTimeButton(_time, Icons.schedule_outlined, _pickTime),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton.icon(
                          onPressed: _prepareSubmission,
                          icon: const Icon(Icons.cloud_upload_outlined),
                          label: const Text('Enviar para o Supabase'),
                          style: FilledButton.styleFrom(
                            backgroundColor: _orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  // Constrói a interface interna do retângulo 9:16 da câmera
  Widget _buildCameraContent() {
    // 1. Se a foto foi tirada, mostra a foto e as opções de confirmar/refazer
    if (_capturedImage != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.file(File(_capturedImage!.path), fit: BoxFit.cover),
          if (!_isPhotoConfirmed)
            Container(
              color: Colors.black.withAlpha(150),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton.icon(
                    onPressed: _confirmPhoto,
                    icon: const Icon(Icons.check),
                    label: const Text('Confirmar Foto'),
                    style: FilledButton.styleFrom(backgroundColor: _brightBlue),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _retakePhoto,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tirar Outra'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          // Indicador visual quando a foto já está confirmada
          if (_isPhotoConfirmed)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 20),
              ),
            )
        ],
      );
    }
    
    // 2. Se a câmera ainda está carregando, mostra o loading
    if (!_isCameraInitialized) {
      return const Center(child: CircularProgressIndicator(color: _paleBlue));
    }
    
    // 3. Mostra o feed ao vivo da câmera para tirar a foto
    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(_cameraController!),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Center(
            child: FloatingActionButton(
              onPressed: _takePhoto,
              backgroundColor: _orange,
              elevation: 0,
              shape: const CircleBorder(),
              child: const Icon(Icons.camera_alt, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: Theme.of(context).textTheme.titleSmall?.copyWith(
      color: _blue, fontWeight: FontWeight.w700,
    ),
  );

  Widget _dateTimeButton(String value, IconData icon, VoidCallback onPressed) =>
      Expanded(
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          label: Text(value),
          style: OutlinedButton.styleFrom(
            foregroundColor: _blue,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
        ),
      );
}