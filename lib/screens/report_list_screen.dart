import 'package:flutter/material.dart';

import '../models/denuncia.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({super.key});

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  final ApiService apiService = ApiService();
  final AuthService _authService = AuthService();
  late Future<List<Denuncia>> futureDenuncias;

  @override
  void initState() {
    super.initState();
    futureDenuncias = apiService.getDenuncias();
  }

  Future<void> _refresh() async {
    setState(() {
      futureDenuncias = apiService.getDenuncias();
    });
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (!mounted) return;

    // Limpia el stack de navegación y vuelve al login
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Denuncias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: _logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Denuncia>>(
          future: futureDenuncias,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No hay denuncias aún.'));
            }

            final denuncias = snapshot.data!;
            return ListView.builder(
              itemCount: denuncias.length,
              itemBuilder: (context, index) {
                final d = denuncias[index];
                return ListTile(
                  leading: d.fotoUrl.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      d.fotoUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Icon(Icons.report),
                  title: Text(d.correo),
                  subtitle: Text(
                    d.descripcion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: d,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/new').then((_) => _refresh());
        },
        icon: const Icon(Icons.add),
        label: const Text('Nueva denuncia'),
      ),
    );
  }
}
