import 'filterChain.dart';
import 'struct_credenciales.dart';
import 'target.dart';
import 'sensorFiltro.dart';

class FilterManager {
  late FilterChain _filterChain;

  FilterManager(Target target, SensorFiltro sensor) {
    _filterChain = FilterChain(target, sensor);
  }

  void addFilter(dynamic filter) {
    _filterChain.addFilter(filter);
  }

  void mandarMensaje(Credenciales mensaje) {
    _filterChain.ejecutar(mensaje);
  }
}
