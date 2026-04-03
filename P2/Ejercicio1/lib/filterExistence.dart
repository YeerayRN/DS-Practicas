import 'filter.dart';
import 'struct_credenciales.dart';

class FilterExistence implements Filter{
  List<String> emails = [];

  @override
  bool ejecutar(Credenciales credenciales){    
    
    if(!emails.contains(credenciales.correo)){
      emails.add(credenciales.correo);
      return true;
    }
    else{
      return false;
    }
  }

  String msgerror(){
    return "Ya existe un usuario con ese correo. Intenta iniciar sesión";
  }
}