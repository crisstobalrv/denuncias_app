import 'package:flutter/material.dart';
import '../models/denuncia.dart';

class ReportDetailScreen extends StatelessWidget {
  final Denuncia denuncia;

  const ReportDetailScreen({super.key, required this.denuncia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de denuncia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (denuncia.fotoUrl.isNotEmpty)
              Image.network(
                denuncia.fotoUrl,
                height: 200,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            Text(
              denuncia.correo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(denuncia.descripcion),
            const SizedBox(height: 16),
            Text('Ubicación: ${denuncia.lat}, ${denuncia.lng}'),
            const SizedBox(height: 8),
            Text('Fecha: ${denuncia.fecha}'),
          ],
        ),
      ),
    );
  }
}
