import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/denuncia.dart';

class ApiService {
  static const String baseUrl = 'https://unknighted-forcingly-lavelle.ngrok-free.dev/api';

  Future<List<Denuncia>> getDenuncias() async {
    final url = Uri.parse('$baseUrl/denuncias');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Denuncia.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener denuncias');
    }
  }

  Future<Denuncia> getDenunciaById(int id) async {
    final url = Uri.parse('$baseUrl/denuncias/$id');
    final response = await http.get(url);

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

    final request = http.MultipartRequest('POST', url)
      ..fields['correo'] = correo
      ..fields['descripcion'] = descripcion
      ..fields['lat'] = lat.toString()
      ..fields['lng'] = lng.toString()
      ..files.add(await http.MultipartFile.fromPath('foto', imagen.path));

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode != 201) {
      throw Exception('Error al crear denuncia: ${response.body}');
    }
  }
}
