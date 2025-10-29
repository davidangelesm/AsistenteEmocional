import 'dart:convert';
import 'package:http/http.dart' as http;
import '../configs/api_config.dart'; // Asegúrate que la ruta sea correcta
// Puedes considerar importar tus modelos si necesitas pasar el historial formateado
// import '../models/mensaje.dart';
// import '../models/remitente_type.dart';

class GeminiAIService {
  // Considera renombrar esta clase a algo como LocalAIService o LMStudioService
  // Usar la configuración centralizada del API
  static String get _backendUrl =>
      ApiConfig.baseUrl; // Usamos baseUrl que definiste en ApiConfig

  /// Enviar mensaje a través de nuestro backend (ahora usando LM Studio local)
  ///
  /// [message]: El mensaje actual del usuario.
  /// [history]: (Opcional) Una lista de mensajes previos en formato Map [{'role': 'user'/'assistant', 'content': '...'}].
  Future<String> sendMessage(String message,
      {List<Map<String, String>>? history}) async {
    try {
      final url =
          Uri.parse('$_backendUrl/api/genai'); // Ruta completa del endpoint

      // --- CAMBIO CLAVE: Adaptar el cuerpo de la solicitud ---
      final requestBody = {
        'prompt': message, // Cambiado de 'contents' a 'prompt'
        'history': history ??
            [], // Añadido campo 'history', envía lista vacía si es null
      };
      // --- FIN CAMBIO ---

      print('🚀 Enviando mensaje al backend local...');
      print('📤 URL: $url');
      print('📝 Prompt: $message');
      if (history != null && history.isNotEmpty) {
        print('📜 Historial enviado: ${history.length} mensajes');
      }
      // print('📦 Body a enviar: ${json.encode(requestBody)}'); // Descomenta para depurar el body exacto

      final response = await http.post(
        url,
        headers: {
          'Content-Type':
              'application/json; charset=UTF-8', // Especificar charset UTF-8 es buena práctica
        },
        body: json.encode(requestBody),
      );

      print('📨 Response status: ${response.statusCode}');
      // Decodificar correctamente si el cuerpo tiene caracteres especiales (tíldes, etc.)
      final responseBody = utf8.decode(response.bodyBytes);
      print('📋 Response body: $responseBody');

      if (response.statusCode == 200) {
        final responseData = json.decode(responseBody);

        // --- CAMBIO CLAVE: Adaptar la clave de respuesta ---
        if (responseData['respuesta'] != null) {
          // Cambiado de 'text' a 'respuesta'
          print('✅ Respuesta del backend local recibida');
          return responseData['respuesta'];
        } else {
          print(
              '❌ Error: Formato de respuesta inesperado del backend (falta "respuesta").');
          throw Exception('Formato de respuesta inesperado del backend');
        }
        // --- FIN CAMBIO ---
      } else if (response.statusCode == 400) {
        // Intenta decodificar el error del backend
        try {
          final errorData = json.decode(responseBody);
          final errorMessage = errorData['error'] ?? 'Error desconocido (400)';
          print('❌ Error 400 del backend: $errorMessage');
          throw Exception('Error del backend: $errorMessage');
        } catch (e) {
          print(
              '❌ Error 400 del backend, pero no se pudo decodificar el cuerpo: $responseBody');
          throw Exception('Error de solicitud al backend (400)');
        }
      } else {
        print(
            '❌ Error ${response.statusCode} del servidor backend: $responseBody');
        throw Exception('Error del servidor backend (${response.statusCode})');
      }
    } catch (e) {
      print('❌ Error en ${runtimeType.toString()}: $e');
      // Decide si quieres relanzar el error original o uno más genérico
      // rethrow; // Relanza el error original (puede incluir detalles de conexión)
      // O lanza uno más genérico para la UI:
      throw Exception(
          'No se pudo comunicar con el servicio de IA. Verifica la conexión con el backend.');
    }
  }

  /// Verificar conexión con la raíz del backend
  Future<bool> validateConnection() async {
    try {
      // Apunta a la ruta raíz que definiste en index.js
      final url = Uri.parse(
          _backendUrl); // Debería apuntar a algo como http://<ip>:3001/
      print('🔄 Verificando conexión con el backend en: $url');
      final response =
          await http.get(url, headers: {'Accept': 'application/json'});
      print('✔️ Estado de conexión: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Error validando conexión con el backend: $e');
      return false;
    }
  }

  /// Obtener información de los modelos disponibles (adaptado para local)
  Future<List<String>> getAvailableModels() async {
    // NOTA: LM Studio no expone fácilmente una lista de modelos vía API estándar.
    // Podrías:
    // 1. Llamar a una ruta específica del backend si la creas para devolver el modelo configurado.
    // 2. Devolver un valor fijo indicando que es un modelo local.
    // 3. Quitar esta funcionalidad si no es necesaria.

    // Opción 2: Valor fijo
    print('ℹ️ Usando modelo local configurado en el backend.');
    return ['Modelo Local (LM Studio)'];

    /*
    // Opción 1: Llamar al backend (si implementas /api/genai/models)
    try {
      final url = Uri.parse('$_backendUrl/api/genai/models');
      final response = await http.get(url, headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
         final data = json.decode(utf8.decode(response.bodyBytes));
         // Asumiendo que el backend devuelve { "models": [{"name": "identificador..."}] }
         List<dynamic> modelsData = data['models'] ?? [];
         return modelsData.map((model) => model['name'].toString()).toList();
      } else {
         print('⚠️ Error obteniendo modelos del backend (${response.statusCode}), usando fallback.');
        return ['Modelo Local (Error)'];
      }
    } catch (e) {
      print('❌ Error obteniendo modelos del backend: $e');
      return ['Modelo Local (Error Conexión)'];
    }
    */
  }
}
