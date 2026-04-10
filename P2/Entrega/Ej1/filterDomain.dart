import 'filter.dart';
import 'struct_credenciales.dart';

class FilterDomain extends Filter {
  static const List<String> validNames = ['@gmail', '@hotmail'];
  static const List<String> validExtensions = ['.com', '.es'];

  @override
  bool ejecutar(Credenciales credenciales) {
    String patron = r'@(' + validNames.join('|') + r')\.(' + validExtensions.join('|') + r')$';

    RegExp regex = RegExp(patron);

    return regex.hasMatch(credenciales.correo);
  }

  @override
    String msgerror(){
        return "Dominio no válido. El correo debe pertenecer a los dominios \'@gmail.com\' o \'@hotmail.com\'.";
    }
}
