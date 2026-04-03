import 'sensor.dart';
import 'observer.dart';

class SensorFiltro implements Sensor {
  List<Observer> _observadores = [];
  String _error = "";

  @override
  void addObserver(Observer observador){
    _observadores.add(observador);
  }

  @override
  void removeObserver(Observer observador){
    Type tipo = observador.runtimeType;

    _observadores.removeWhere((item) => item.runtimeType == tipo);
  }

  @override
  void setError(String newError){
    _error = newError;
  }

  @override
  void notifyObservers(){
    for(Observer i in _observadores){
      i.update(_error);
    }
  }
}