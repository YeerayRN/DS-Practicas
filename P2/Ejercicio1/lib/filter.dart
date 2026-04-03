import 'struct_credenciales.dart';

abstract class Filter{
  static List<String> _emails = [];

  bool ejecutar(Credenciales mensaje);

  String msgerror();

  static void addEmail(String email){
    _emails.add(email);
  }

  static List<String> getEmails(){
    return _emails;
  }
}