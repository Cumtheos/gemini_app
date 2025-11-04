import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Implementacion de Gemini usando Dio para hacer peticiones HTTP
// sirve como capa de abstraccion para interactuar con la API de Gemini
// esto se realiza para separar la logica de negocio de la logica de red
// facilitando el mantenimiento y las pruebas

class GeminiImpl {
  final Dio _http = Dio(
    BaseOptions(
      baseUrl: dotenv.env['ENDPOINT_API'] ?? '',
      headers: {
        'Content-Type': 'application/json', // Importante!
      },
    ),
  );

  Future<String> getResponse(String prompt) async {
    try {
      final body = jsonEncode({'prompt': prompt});
      //jsonEnconde es para convertir un mapa a un string json
      final response = await _http.post('/basic-prompt', data: body);
      print(response.data);
      return response.data;
    } catch (e) {
      print(e);
      throw Exception('Error al obtener respuesta de Gemini');
    }
  }
}
