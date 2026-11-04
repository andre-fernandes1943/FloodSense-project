import 'dart:convert';
import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart';

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

  final ImagePicker _picker = ImagePicker();
  XFile? _capturedImage; 

  bool _carregando = false;

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

  // =========================================================================
  // TIRAR FOTO COM CÂMERA (COM COMPRESSÃO E LIMITE DE DIMENSÃO)
  // =========================================================================
  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        maxWidth: 1024,   // <--- REDUZ A LARGURA PARA EVITAR PAYLOAD PESADO
        maxHeight: 1024,  // <--- REDUZ A ALTURA
        imageQuality: 70, // <--- COMPRIME A IMAGEM
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

  // =========================================================================
  // SELECIONAR FOTO DA GALERIA (COM COMPRESSÃO)
  // =========================================================================
  Future<void> _pickFromGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,   // <--- REDUZ A LARGURA
        maxHeight: 1024,  // <--- REDUZ A ALTURA
        imageQuality: 70, // <--- COMPRIME A IMAGEM
      );
      
      if (photo != null) {
        setState(() {
          _capturedImage = photo;
        });
      }
    } catch (e) {
      debugPrint('Erro ao abrir galeria: $e');
    }
  }

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

  // =========================================================================
  // FUNÇÃO DE ENVIO DA OCORRÊNCIA COM SUPABASE E RESERVA PARA GEMINI IA
  // =========================================================================
  Future<void> _prepareSubmission() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_capturedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, tire uma foto do alagamento antes de enviar.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      final usuarioAtual = Supabase.instance.client.auth.currentUser;
      if (usuarioAtual == null) throw 'Usuário não autenticado.';

      // 1. CONVERTE A IMAGEM COMPRIMIDA EM BASE64
      final bytes = await File(_capturedImage!.path).readAsBytes();
      final base64Image = base64Encode(bytes);

      // 2. CHAMA A EDGE FUNCTION NO SUPABASE
      final FunctionResponse res = await Supabase.instance.client.functions.invoke(
        'analisar-imagem-router',
        body: {
          'base64': base64Image,
          'mimeType': 'image/jpeg',
        },
      );

      // TRATAMENTO SEGURO DO RETORNO DA EDGE FUNCTION
      Map<String, dynamic> resultadoIA = {};
      if (res.data is Map<String, dynamic>) {
        resultadoIA = res.data as Map<String, dynamic>;
      } else if (res.data is String) {
        resultadoIA = jsonDecode(res.data as String);
      }

      bool fotoAprovadaPelaIA = resultadoIA['ehAlagamento'] ?? false;
      String categoriaIdentificada = resultadoIA['categoria'] ?? 'inconclusivo';

      // 3. SE NÃO FOR ALAGAMENTO, BARRA O REGISTRO
      if (!fotoAprovadaPelaIA) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Não conseguimos identificar uma enchente nesta foto. Por favor, tente tirar uma foto mais clara do alagamento.',
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );

          setState(() {
            _capturedImage = null;
          });
        }
        return;
      }

      // 4. UPLOAD PARA O STORAGE (BUCKET 'ocorrencias')
      final arquivoFoto = File(_capturedImage!.path);
      final nomeArquivo = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final caminhoStorage = '${usuarioAtual.id}/$nomeArquivo';

      await Supabase.instance.client.storage
          .from('ocorrencias')
          .upload(caminhoStorage, arquivoFoto);

      final urlPublicaFoto = Supabase.instance.client.storage
          .from('ocorrencias')
          .getPublicUrl(caminhoStorage);

      // 5. INSERE A OCORRÊNCIA NA TABELA 'public.ocorrencia'
      final respostaOcorrencia = await Supabase.instance.client
          .from('ocorrencia')
          .insert({
            'id_usuario': usuarioAtual.id,
            'descricao': _descriptionController.text.trim(),
            'latitude': -23.5505,
            'longitude': -46.6333,
          })
          .select()
          .single();

      final int idOcorrenciaGerado = respostaOcorrencia['id_ocorrencia'];

      // 6. INSERE O LINK DA FOTO NA TABELA 'public.imagem'
      await Supabase.instance.client.from('imagem').insert({
        'id_ocorrencia': idOcorrenciaGerado,
        'caminho_imagem': urlPublicaFoto,
      });

      // 7. INSERE O RESULTADO DA ANÁLISE NA TABELA 'public.analise_ia'
      await Supabase.instance.client.from('analise_ia').insert({
        'id_ocorrencia': idOcorrenciaGerado,
        'resultado': 'APROVADA',
        'classificacao': categoriaIdentificada,
        'nivel_confianca': 90,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto analisada com sucesso! Ocorrência registrada.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );

        _descriptionController.clear();
        _locationController.clear();
        setState(() {
          _capturedImage = null;
        });
      }

    } catch (erro) {
      if (mounted) {
        final erroString = erro.toString();
        String mensagemAmigavel = 'Ocorreu um erro ao registrar a ocorrência. Por favor, tente novamente.';

        if (erroString.contains('503') || 
            erroString.contains('502') || 
            erroString.contains('high demand') || 
            erroString.contains('Bad Gateway')) {
          mensagemAmigavel = 'O serviço de análise está temporariamente indisponível. Por favor, tente enviar novamente em alguns segundos.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(mensagemAmigavel),
            backgroundColor: const Color.fromARGB(255, 102, 7, 0),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
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
                          hintText: 'Descreva o nível da água ou perigos no local',
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
                          onPressed: _carregando ? null : _prepareSubmission,
                          icon: _carregando 
                              ? const SizedBox.shrink() 
                              : const Icon(Icons.send_rounded),
                          label: _carregando
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20, 
                                      height: 20, 
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                    ),
                                    SizedBox(width: 12),
                                    Text('Analisando foto e enviando...'),
                                  ],
                                )
                              : const Text('Enviar ocorrência', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_a_photo_outlined, size: 44, color: Colors.white70),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: _takePhoto,
                  icon: const Icon(Icons.camera_alt, size: 18),
                  label: const Text('Câmera'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _orange,
                    foregroundColor: Colors.white,
                  ),
                ),
                FilledButton.icon(
                  onPressed: _pickFromGallery,
                  icon: const Icon(Icons.photo_library, size: 18),
                  label: const Text('Galeria'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _brightBlue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
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
