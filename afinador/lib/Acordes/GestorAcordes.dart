import 'package:afinador/Acordes/Acorde.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GestorAcordes {
  List<Acorde> _acordes = [];
  String usuario = "";
  String apiURL = "";
  String ip = "";

  GestorAcordes({this.ip = "localhost", this.usuario = "defaultUser"}){
    apiURL = "http://${ip}:3000/usuarios/$usuario/acordes";
  }

  Future<void> iniciarSesion(String nombreUsuario) async {
    usuario = nombreUsuario;
    apiURL = "http://$ip:3000/usuarios/$usuario/acordes";

    // Intentar crear el usuario en el servidor
    await http.post(
      Uri.parse("http://$ip:3000/usuarios"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nombre': usuario}),
    );

    // Cargar sus acordes
    await cargarAcordes();
  }

  Future<void> cargarAcordes() async{
    final response = await http.get(Uri.parse('$apiURL?usuario=$usuario'));
    if (response.statusCode == 200) {
      List<dynamic> tareasJson = json.decode(response.body);

      _acordes.clear();
      _acordes.addAll(tareasJson.map((json) => Acorde.fromJson(json)).toList());
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> agregar(Acorde acorde) async {
    final response = await http.post(
      Uri.parse(apiURL),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(acorde.toJson()),
    );

    if (response.statusCode == 201) {
      _acordes.add(Acorde.fromJson(json.decode(response.body)));
    } else {
      throw Exception('Failed to add task: ${response.body}');
    }
  }

  Future<void> eliminar(Acorde acorde) async{
    final response = await http.delete(
      Uri.parse('$apiURL/${acorde.id}'),
    );
    if (response.statusCode == 200) {
      _acordes.removeWhere((a) => a.id == acorde.id);
      print("acorde eliminado de BD");
    } else {
      throw Exception('Failed to delete task');
    }
  }

  Future<void> editar(int idAcorde, Acorde nuevo) async{
    nuevo.id = idAcorde; //Por si acaso no es el mismo

    final response = await http.patch(
      Uri.parse('$apiURL/${idAcorde}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(nuevo.toJson()),
    );

    if (response.statusCode == 200) {
      _acordes.removeWhere((a) => a.id == idAcorde);
      _acordes.add(nuevo);
      print("Acorde guardado en BD");
    } else {
      throw Exception('Failed to update task');
    }
  }

  void addAcorde(Acorde a){
    _acordes.add(a);
  }

  void removeAcorde(Acorde a){
    _acordes.remove(a);
  }

  List<Acorde> getAcordes(){
    return _acordes;
  }

  void editAcorde(){

  }
}