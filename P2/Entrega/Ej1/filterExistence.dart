import 'filter.dart';
import 'struct_credenciales.dart';

class FilterExistence extends Filter{
  @override
  bool ejecutar(Credenciales credenciales){    
    List<String> emails = Filter.getEmails();

    if(!emails.contains(credenciales.correo)){
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