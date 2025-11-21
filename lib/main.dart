import 'package:flutter/material.dart';
import 'screens/new_report_screen.dart';
import 'screens/report_list_screen.dart';
import 'screens/report_detail_screen.dart';
import 'models/denuncia.dart';

void main() {
  runApp(const DenunciasApp());
}

class DenunciasApp extends StatelessWidget {
  const DenunciasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Denuncias DUOC',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      initialRoute: '/list',
      routes: {
        '/list': (context) => const ReportListScreen(),
        '/new': (context) => const NewReportScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final denuncia = settings.arguments as Denuncia;
          return MaterialPageRoute(
            builder: (_) => ReportDetailScreen(denuncia: denuncia),
          );
        }
        return null;
      },
    );
  }
}
