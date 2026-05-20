import 'package:afinador/Afinador/datosAfinador.dart';

abstract class EstrategiaAfinador {
  void initRec(void Function(DatosAfinador) onDatos);

  void endRec();

  String getNota();

  double getFrecuencia();

  double getDesviacion();

  bool isAfinado();

  void reiniciarDatos();
}