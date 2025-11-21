import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

import '../services/api_service.dart';

class NewReportScreen extends StatefulWidget {
  const NewReportScreen({super.key});

  @override
  State<NewReportScreen> createState() => _NewReportScreenState();
}

class _NewReportScreenState extends State<NewReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _descripcionController = TextEditingController();
  final ApiService apiService = ApiService();

  File? _imagen;
  double? _lat;
  double? _lng;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);

    if (picked != null) {
      setState(() {
        _imagen = File(picked.path);
      });
    }
  }

  Future<void> _getLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _lat = position.latitude;
      _lng = position.longitude;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imagen == null || _lat == null || _lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falta imagen o ubicación')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await apiService.crearDenuncia(
        correo: _correoController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        lat: _lat!,
        lng: _lng!,
        imagen: _imagen!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Denuncia enviada con éxito')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _correoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Denuncia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _correoController,
                decoration: const InputDecoration(
                  labelText: 'Correo DUOC',
                  hintText: 'alumno@duoc.cl',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese su correo';
                  }
                  if (!value.contains('@')) {
                    return 'Correo inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese descripción';
                  }
                  if (value.length < 10) {
                    return 'Describa con más detalle';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Tomar foto'),
                  ),
                  const SizedBox(width: 16),
                  if (_imagen != null)
                    const Icon(Icons.check_circle, size: 32),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _getLocation,
                    icon: const Icon(Icons.location_on),
                    label: const Text('Obtener ubicación'),
                  ),
                  const SizedBox(width: 16),
                  if (_lat != null && _lng != null)
                    const Icon(Icons.check_circle, size: 32),
                ],
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _submit,
                child: const Text('Enviar denuncia'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
