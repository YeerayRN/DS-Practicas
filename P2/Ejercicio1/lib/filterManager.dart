import 'filterChain.dart';
import 'struct_credenciales.dart';
import 'target.dart';
import 'sensorFiltro.dart';
import 'filter.dart';

class FilterManager {
  late FilterChain _filterChain;

  FilterManager(Target target, SensorFiltro sensor) {
    _filterChain = FilterChain(target, sensor);
  }

  void addFilter(Filter filter) {
    _filterChain.addFilter(filter);
  }

  void mandarMensaje(Credenciales mensaje) {
    _filterChain.ejecutar(mensaje);
  }
}
