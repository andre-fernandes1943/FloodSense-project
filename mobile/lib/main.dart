import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const OccurrenceApp());

const _blue = Color(0xFF0754A5);
const _brightBlue = Color(0xFF168EE5);
const _paleBlue = Color(0xFFE8F7FF);
const _orange = Color(0xFFFF861D);

typedef PhotoPicker = Future<XFile?> Function();

class OccurrenceApp extends StatelessWidget {
  const OccurrenceApp({super.key, this.photoPicker});

  final PhotoPicker? photoPicker;

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
        home: OccurrenceFormPage(photoPicker: photoPicker),
      );
}

class OccurrenceFormPage extends StatefulWidget {
  const OccurrenceFormPage({super.key, this.photoPicker});

  final PhotoPicker? photoPicker;

  @override
  State<OccurrenceFormPage> createState() => _OccurrenceFormPageState();
}

class _OccurrenceFormPageState extends State<OccurrenceFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime _occurredAt = DateTime.now();
  Uint8List? _photoBytes;
  String? _photoName;
  double? _latitude;
  double? _longitude;
  bool _isLocating = false;
  bool _isCapturing = false;
  bool _photoError = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  String get _date =>
      '${_two(_occurredAt.day)}/${_two(_occurredAt.month)}/${_occurredAt.year}';
  String get _time => '${_two(_occurredAt.hour)}:${_two(_occurredAt.minute)}';
  String _two(int value) => value.toString().padLeft(2, '0');

  Future<void> _pickDate() async {
    final value = await showDatePicker(
      context: context,
      initialDate: _occurredAt,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (value == null) return;
    setState(() => _occurredAt = DateTime(
          value.year,
          value.month,
          value.day,
          _occurredAt.hour,
          _occurredAt.minute,
        ));
  }

  Future<void> _pickTime() async {
    final value = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_occurredAt),
    );
    if (value == null) return;
    setState(() => _occurredAt = DateTime(
          _occurredAt.year,
          _occurredAt.month,
          _occurredAt.day,
          value.hour,
          value.minute,
        ));
  }

  Future<void> _takePhoto() async {
    if (_isCapturing) return;
    setState(() => _isCapturing = true);
    try {
        if (!kIsWeb &&
          defaultTargetPlatform == TargetPlatform.android &&
          widget.photoPicker == null) {
        final permission = await Permission.camera.request();
        if (!permission.isGranted) {
          throw Exception(
            permission.isPermanentlyDenied
                ? 'Libere o acesso à câmera nas configurações do aparelho.'
                : 'A permissão da câmera é necessária para registrar a ocorrência.',
          );
        }
      }

      final photo = widget.photoPicker == null
          ? await _imagePicker.pickImage(
              source: ImageSource.camera,
              imageQuality: 80,
              maxWidth: 1600,
            )
          : await widget.photoPicker!();
      if (photo == null) return;

      final bytes = await photo.readAsBytes();
      if (!mounted) return;
      setState(() {
        _photoBytes = bytes;
        _photoName = photo.name.isEmpty ? 'foto-ocorrencia' : photo.name;
        _photoError = false;
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isLocating = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw Exception('Ative o serviço de localização do aparelho.');
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização não concedida.');
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Libere a localização nas configurações do aparelho.');
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );
      if (!mounted) return;
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _locationController.text =
            '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  Map<String, dynamic> _buildPayload() => {
      'descricao': _descriptionController.text.trim(),
      'localizacao': _locationController.text.trim(),
      'dataHora': _occurredAt.toIso8601String(),
      if (_latitude != null) 'latitude': _latitude,
      if (_longitude != null) 'longitude': _longitude,
      'fotoNome': _photoName,
      'fotoBase64': base64Encode(_photoBytes!),
    };

  Future<void> _prepareSubmission() async {
    final fieldsAreValid = _formKey.currentState!.validate();
    setState(() => _photoError = _photoBytes == null);
    if (!fieldsAreValid || _photoBytes == null) return;

    final previewPayload = Map<String, dynamic>.from(_buildPayload())
      ..['fotoBase64'] = '[conteúdo da foto: ${_photoBytes!.length} bytes]';
    final json = const JsonEncoder.withIndent('  ').convert(previewPayload);
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dados prontos para envio'),
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
              Text('FloodSense', style: TextStyle(color: _blue, fontWeight: FontWeight.w700)),
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
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x22084D86),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add_a_photo_outlined, color: Colors.white, size: 30),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Registrar ocorrência',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
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
                        color: Colors.white.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionLabel('Foto da ocorrência'),
                          const SizedBox(height: 8),
                          if (_photoBytes != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                _photoBytes!,
                                width: double.infinity,
                                height: 190,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (_photoBytes != null) const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: _isCapturing ? null : _takePhoto,
                            icon: _isCapturing
                                ? const SizedBox.square(
                                    dimension: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.photo_camera_outlined),
                            label: Text(
                              _isCapturing
                                  ? 'Abrindo câmera...'
                                  : _photoBytes == null
                                      ? 'Tirar foto'
                                      : 'Tirar outra foto',
                            ),
                            style: OutlinedButton.styleFrom(foregroundColor: _blue),
                          ),
                          if (_photoError)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'Tire uma foto para registrar a ocorrência.',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
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
                            validator: (value) => value == null || value.trim().isEmpty
                                ? 'Informe a descrição da ocorrência.'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          _sectionLabel('Localização'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _locationController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              hintText: 'Endereço, referência ou coordenadas',
                              prefixIcon: Icon(Icons.location_on_outlined),
                            ),
                            validator: (value) => value == null || value.trim().isEmpty
                                ? 'Informe a localização da ocorrência.'
                                : null,
                            onChanged: (_) {
                              if (_latitude != null || _longitude != null) {
                                setState(() {
                                  _latitude = null;
                                  _longitude = null;
                                });
                              }
                            },
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: _isLocating ? null : _useCurrentLocation,
                              icon: _isLocating
                                  ? const SizedBox.square(
                                      dimension: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.my_location_outlined),
                              label: Text(_isLocating ? 'Obtendo localização...' : 'Usar localização atual'),
                            ),
                          ),
                          const SizedBox(height: 8),
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
                              icon: const Icon(Icons.send_outlined),
                              label: const Text('Preparar envio'),
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

  Widget _sectionLabel(String text) => Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: _blue,
              fontWeight: FontWeight.w700,
            ),
      );

  Widget _dateTimeButton(String value, IconData icon, VoidCallback onPressed) => Expanded(
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
