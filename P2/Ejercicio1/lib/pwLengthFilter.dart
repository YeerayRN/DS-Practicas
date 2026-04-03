import 'filter.dart';
import 'struct_credenciales.dart';

class PwLengthFilter implements Filter {
  static const int _minLength = 10;
  static const int _maxLength = 128;
  String _error = "";

  @override
  bool ejecutar(Credenciales mensaje) {

    if (mensaje.password.isEmpty) {
      _error = "La contraseña no puede estar vacía";
      return false;
    }
    
    if (mensaje.password.length < _minLength) {
      _error = 'La contraseña debe tener al menos $_minLength caracteres';
      return false;
    }
    
    if (mensaje.password.length > _maxLength) {
      _error = "La contraseña no puede exceder $_maxLength caracteres";
      return false;
    }

    return true;
  }

  @override
  String msgerror(){
    return _error;
  }
}