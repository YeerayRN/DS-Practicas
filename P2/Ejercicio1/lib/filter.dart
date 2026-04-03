import 'struct_credenciales.dart';

abstract class Filter{
  bool ejecutar(Credenciales mensaje);
  String msgerror();
}