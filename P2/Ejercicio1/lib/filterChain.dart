import 'struct_credenciales.dart';
import 'filter.dart';
import 'target.dart';
import 'sensorFiltro.dart';

class FilterChain{
  List<Filter> _filters = [];
  Target _target;
  SensorFiltro _sensor;

  FilterChain(this._target, this._sensor);

  void setTarget(Target target){
    _target = target;
  }

  void addFilter(Filter filter){
    _filters.add(filter);
  }
  
  @override
  void ejecutar(Credenciales mensaje){

    for(int i = 0; i < _filters.length; i++){
      bool result = _filters[i].ejecutar(mensaje);

      if(!result){
        _sensor.setError(_filters[i].msgerror());
        return;
      }
    }
    
    _target.ejecutar(mensaje);
  }
}