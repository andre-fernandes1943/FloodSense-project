import 'dart:convert';
import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 

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
  
  DateTime _occurredAt = DateTime.now().toUtc().subtract(const Duration(hours: 3));

  // Variáveis para a Câmera Nativa (Removida a variável _isPhotoConfirmed)
  final ImagePicker _picker = ImagePicker();
  XFile? _capturedImage; 

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
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

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );
      
      if (photo != null) {
        setState(() {
          _capturedImage = photo;
        });
      }
    } catch (e) {
      debugPrint('Erro ao abrir câmera nativa: $e');
    }
  }

  // Apenas descarta a foto atual e reabre a câmera nativa
  void _retakePhoto() {
    setState(() {
      _capturedImage = null;
    });
    _takePhoto(); 
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _locationController.text = "Buscando localização atual...";
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          _locationController.text = "Av. Paulista, 1578 - São Paulo, SP";
        }
      });
    });
  }

  Future<void> _prepareSubmission() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Validação ajustada: apenas verifica se a foto foi tirada
    if (_capturedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, tire uma foto antes de enviar.')),
      );
      return;
    }

    final payload = {
      'descricao': _descriptionController.text.trim(),
      'localizacao': _locationController.text.trim(),
      'dataHora': _occurredAt.toIso8601String(),
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
                    color: Colors.white.withAlpha(240),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel('Foto da ocorrência'),
                      const SizedBox(height: 8),
                      
                      Center(
                        child: SizedBox(
                          height: 380, 
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: AspectRatio(
                              aspectRatio: 9 / 16, 
                              child: Container(
                                color: const Color(0xFF2C3E50), 
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

  Widget _buildCameraContent() {
    // 1. Se a foto já foi tirada, mostra a imagem limpa e os ícones no canto
    if (_capturedImage != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.file(File(_capturedImage!.path), fit: BoxFit.cover),
          Positioned(
            top: 10,
            right: 10,
            child: Row(
              children: [
                // Botão de Refazer Foto
                GestureDetector(
                  onTap: _retakePhoto,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(150),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.refresh, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 8),
                // Indicador visual de Concluído
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 20),
                ),
              ],
            ),
          )
        ],
      );
    }
    
    // 2. Se a foto não foi tirada ainda, exibe o botão para abrir a câmera do celular
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_a_photo_outlined, size: 48, color: Colors.white70),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _takePhoto,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Abrir Câmera'),
            style: FilledButton.styleFrom(
              backgroundColor: _orange,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
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