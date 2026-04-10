import 'filter.dart';
import 'struct_credenciales.dart';

class PwCharactersFilter extends Filter {
  static final RegExp _specialCharacters = RegExp(r'[!#$%&()*+,\-./\\:;<=>?@\[\]^_{|}~`]');

  @override
  bool ejecutar(Credenciales credenciales) {
    return _specialCharacters.hasMatch(credenciales.password);
  }

  @override
  String msgerror(){
    return "Comprobación de caracteres especiales incorrecta. Por favor, añada algunos a su contraseña.";
  }
}
