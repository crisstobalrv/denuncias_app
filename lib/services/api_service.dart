import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/denuncia.dart';
import 'auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'https://unknighted-forcingly-lavelle.ngrok-free.dev/api';

  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _buildAuthHeaders({bool isJson = false}) async {
    final token = await _storage.read(key: 'jwt_token');
    final headers = <String, String>{};

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (isJson) {
      headers['Content-Type'] = 'application/json';
    }

    return headers;
  }

  Future<List<Denuncia>> getDenuncias() async {
    final url = Uri.parse('$baseUrl/denuncias');
    final headers = await _buildAuthHeaders(); // si se proteger GET también

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Denuncia.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
      // Token inválido o expirado → podrías redirigir al login
      throw Exception('No autorizado. Inicie sesión nuevamente.');
    } else {
      throw Exception('Error al obtener denuncias');
    }
  }

  Future<Denuncia> getDenunciaById(int id) async {
    final url = Uri.parse('$baseUrl/denuncias/$id');
    final headers = await _buildAuthHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Denuncia.fromJson(data);
    } else {
      throw Exception('Error al obtener denuncia');
    }
  }

  Future<void> crearDenuncia({
    required String correo,
    required String descripcion,
    required double lat,
    required double lng,
    required File imagen,
  }) async {
    final url = Uri.parse('$baseUrl/denuncias');
    final token = await _authService.getToken();

    final request = http.MultipartRequest('POST', url)
      ..fields['correo'] = correo
      ..fields['descripcion'] = descripcion
      ..fields['lat'] = lat.toString()
      ..fields['lng'] = lng.toString()
      ..files.add(await http.MultipartFile.fromPath('foto', imagen.path));

    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 201) {
      return;
    } else if (response.statusCode == 401) {
      throw Exception('No autorizado. Inicie sesión nuevamente.');
    } else if (response.statusCode == 422) {
      throw Exception('Datos incompletos o inválidos.');
    } else {
      throw Exception('Error al crear denuncia: ${response.body}');
    }
  }
}
