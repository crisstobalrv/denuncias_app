import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = 'https://unknighted-forcingly-lavelle.ngrok-free.dev';

  static const _tokenKey = 'jwt_token';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> login(String correo, String password) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'correo': correo,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];
      if (token != null) {
        await _storage.write(key: _tokenKey, value: token);
        return true;
      } else {
        throw Exception('Respuesta sin token');
      }
    } else if (response.statusCode == 401) {
      // Credenciales inválidas
      return false;
    } else {
      throw Exception('Error en login: ${response.statusCode}');
    }
  }

  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }
}
