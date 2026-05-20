import 'package:afinador/Acordes/Acorde.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GestorAcordes {
  List<Acorde> _acordes = [];
  
  int? idUsuario;
  String usuario;
  String ip;
  
  late String apiURLAcordes;
  late String apiURLUsuarios;

  GestorAcordes({this.ip = "127.0.0.1", this.usuario = "DefaultUser", this.idUsuario}) {
    apiURLAcordes = "http://$ip:3000/acordes";
    apiURLUsuarios = "http://$ip:3000/usuarios";
  }

  /// CREAR / INICIAR SESIÓN DE USUARIO
  Future<void> iniciarSesion(String nombreUsuario) async {
    this.usuario = nombreUsuario;

    final response = await http.post(
      Uri.parse(apiURLUsuarios),
      headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
        'usuario': {
          'nombre': nombreUsuario
        }
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      this.idUsuario = data['id']; 
      print("Sesión iniciada. ID en BD: $idUsuario");
      
      await cargarAcordes();
    } else {
      throw Exception('Error al iniciar sesión: ${response.body}');
    }
  }

  /// CARGAR ACORDES (GET)
  Future<void> cargarAcordes() async {
    if (idUsuario == null) return;

    final response = await http.get(Uri.parse(apiURLAcordes));
    
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);

      _acordes.clear();
      
      // Como el endpoint /acordes devuelve todos, filtramos localmente 
      // para quedarnos solo con los del usuario actual
      for (var item in jsonList) {
        if (item['usuario_id'] == idUsuario) {
          _acordes.add(Acorde.fromJson(item));
        }
      }
    } else {
      throw Exception('Error al cargar la lista de acordes');
    }
  }

  /// Añadir acorde (POST)
  Future<void> agregar(Acorde acorde) async {
    if (idUsuario == null) throw Exception("No hay sesión iniciada");

    // Inyectamos el ID del usuario en el objeto antes de enviarlo
    Map<String, dynamic> datosEnviar = acorde.toJson();
    datosEnviar['usuario_id'] = idUsuario;

    final response = await http.post(
      Uri.parse(apiURLAcordes),
      headers: {'Content-Type': 'application/json'},
      // Envolvemos con la clave 'acorde' para los Strong Parameters
      body: jsonEncode({'acorde': datosEnviar}),
    );

    if (response.statusCode == 201) {
      // Usamos la respuesta de la API, que ya viene con el ID del acorde generado
      _acordes.add(Acorde.fromJson(jsonDecode(response.body)));
      print("Acorde guardado exitosamente");
    } else {
      throw Exception('Error al guardar acorde: ${response.body}');
    }
  }

  /// EDITAR ACORDE (PATCH)
  Future<void> editar(int idAcordeBD, Acorde nuevo) async {
    nuevo.id = idAcordeBD; 

    final response = await http.patch(
      Uri.parse('$apiURLAcordes/$idAcordeBD'),
      headers: {'Content-Type': 'application/json'},
      // Solo enviamos los datos del acorde, Rails no necesita que re-enviemos el usuario_id
      body: jsonEncode({'acorde': nuevo.toJson()}),
    );

    if (response.statusCode == 200) {
      // Actualizamos la interfaz local
      int index = _acordes.indexWhere((a) => a.id == idAcordeBD);
      if (index != -1) {
        _acordes[index] = nuevo;
      }
      print("Acorde modificado en BD");
    } else {
      throw Exception('Error al actualizar acorde: ${response.body}');
    }
  }

  /// BORRAR ACORDE (DELETE)
  Future<void> eliminar(Acorde acorde) async {
    if (acorde.id == null) return;

    final response = await http.delete(
      Uri.parse('$apiURLAcordes/${acorde.id}'),
    );
    
    if (response.statusCode == 200 || response.statusCode == 204) {
      _acordes.removeWhere((a) => a.id == acorde.id);
      print("Acorde eliminado de BD");
    } else {
      throw Exception('Error al eliminar acorde');
    }
  }

  // Métodos puros de UI (sin conexión)
  List<Acorde> getAcordes() {
    return _acordes;
  }
}