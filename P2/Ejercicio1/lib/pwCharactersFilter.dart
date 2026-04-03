import 'filter.dart';
import 'struct_credenciales.dart';

class PwCharactersFilter extends Filter {
  static const String _specialCharacters = "!#\$%&'()*+,-./:;<=>?@[\\]^_{|}~`";

  @override
  bool ejecutar(Credenciales credenciales) {
    for (int i = 0; i < credenciales.password.length; i++) {
      if (_specialCharacters.contains(credenciales.password[i])) {
        return true;
      }
    }
    return false;
  }

  @override
  String msgerror(){
    return "Comprobación de caracteres especiales incorrecta. Por favor, añada algunos a su contraseña.";
  }
}
