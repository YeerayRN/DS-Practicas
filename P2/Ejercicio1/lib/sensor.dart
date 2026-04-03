import 'observer.dart';

abstract class Sensor {
  void addObserver(Observer observador);

  void removeObserver(Observer observador);

  void notifyObservers();
}