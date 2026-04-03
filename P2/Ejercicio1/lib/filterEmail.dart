import 'filter.dart';
import 'struct_credenciales.dart';

class FilterEmail extends Filter{
  static const String specialCharacters = "!#\$%&'()*+,-./:;<=>?@[\\]^{|}~`";

  @override
  bool ejecutar(Credenciales credenciales){
    String nombre = credenciales.correo.split("@")[0];

    if(credenciales.correo.contains("@") && '@'.allMatches(credenciales.correo).length == 1  && nombre.isNotEmpty && !nombre.contains(" ")){
      
      for (int i = 0; i < nombre.length; i++) {
        if (specialCharacters.contains(nombre[i])) {
          return false;
        }
      }

      return true;
    }
    
    return false;
  }

  String msgerror(){
    return "El correo electrónico no es válido. Introduzca un formato de correo válido.";
  }
}