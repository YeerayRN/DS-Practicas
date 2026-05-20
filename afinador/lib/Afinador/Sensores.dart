import 'package:afinador/Afinador/Observador.dart';
import 'package:afinador/Afinador/datosAfinador.dart';

abstract class Sensores {
  void addObservador(Observador o);
  void removeObservador(Observador o);
  void notificar(DatosAfinador datos);
}