import 'filter.dart';
import 'struct_credenciales.dart';

class FilterDomain extends Filter {
  static const List<String> validDomains = ['@gmail.com', '@hotmail.com'];

  @override
  bool ejecutar(Credenciales credenciales) {

    for (String domain in validDomains) {
      if (credenciales.correo.endsWith(domain)) {
        return true;
      }
    }
    return false;
  }

  @override
    String msgerror(){
        return "Dominio no válido. El correo debe pertenecer a los dominios \'@gmail.com\' o \'@hotmail.com\'.";
    }
}
