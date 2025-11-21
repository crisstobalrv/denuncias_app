import 'package:flutter/material.dart';
import '../models/denuncia.dart';
import '../services/api_service.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({super.key});

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  final ApiService apiService = ApiService();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Denuncias'),
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
                  leading: const Icon(Icons.report),
                  title: Text(d.correo),
                  subtitle: Text(d.descripcion),
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
