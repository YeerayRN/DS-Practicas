import 'filter.dart';
import 'struct_credenciales.dart';

class PwCapsFilter implements Filter {
  static final _regexMayus = RegExp(r'[A-Z]');
  static final _regexMinus = RegExp(r'[a-z]');

  @override
  bool ejecutar(Credenciales credenciales) {
    final tieneMayus = _regexMayus.hasMatch(credenciales.password);
    final tieneMinuscula = _regexMinus.hasMatch(credenciales.password);

    return (tieneMayus && tieneMinuscula);
  }

  @override
  String msgerror(){
    return "Contraseña no válida: debe contener al menos una letra minúscula y otra mayúscula.";
  }
}