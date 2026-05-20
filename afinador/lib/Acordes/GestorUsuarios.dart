import 'dart:convert';
import 'package:http/http.dart' as http;

class GestorUsuarios {
  final String baseUrl = "http://10.0.2.2:3000";

  /// Envía un POST a la API para registrar un nuevo usuario.
  /// Devuelve el ID generado por la base de datos, o null si ocurre un error.
  Future<int?> registrarUsuario(String nombre) async {
    final url = Uri.parse('$baseUrl/usuarios');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "usuario": {
            "nombre": nombre,
          }
        }),
      );

      if (response.statusCode == 201) {
        // Parseamos el JSON que nos devuelve
        final Map<String, dynamic> usuarioCreado = jsonDecode(response.body);
        print("Usuario creado en el servidor con ID: ${usuarioCreado['id']}");
        
        return usuarioCreado['id'] as int?;
      } else {
        print("Error del servidor al crear usuario: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Excepción de red al crear usuario: $e");
      return null;
    }
  }
}