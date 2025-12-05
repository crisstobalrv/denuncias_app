import 'package:flutter/material.dart';


import 'screens/new_report_screen.dart';
import 'screens/report_list_screen.dart';
import 'screens/report_detail_screen.dart';
import 'screens/login_screen.dart';
import 'models/denuncia.dart';
import 'services/auth_service.dart';

Future<void> main() async {

  runApp(const DenunciasApp());
}

class DenunciasApp extends StatelessWidget {
  const DenunciasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Denuncias DUOC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),

      // Pantalla inicial dinámica
      home: const _RootScreen(),

      // Rutas fijas
      routes: {
        '/login': (context) => const LoginScreen(),
        '/list': (context) => const ReportListScreen(),
        '/new': (context) => const NewReportScreen(),
      },

      // Ruta de detalle con argumentos
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

class _RootScreen extends StatefulWidget {
  const _RootScreen();

  @override
  State<_RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<_RootScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final loggedIn = await _authService.isLoggedIn();
    if (!mounted) return;

    if (loggedIn) {
      Navigator.pushReplacementNamed(context, '/list');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pantalla de carga mientras decide adónde ir
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
