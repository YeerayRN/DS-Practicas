import 'servicio_turistico.dart';

class Paquete implements ServicioTuristico{
  String _nombre;
  List<ServicioTuristico> _servicios;

  Paquete(this._nombre): _servicios = [];

  @override
  double getPrecio(){
    double total = 0.0;

    for(ServicioTuristico s in _servicios){
      total += s.getPrecio();
    }

    return total;
  }

  void addServicio(ServicioTuristico servicio){
    _servicios.add(servicio);
  }

  void clearServicios(){
    _servicios.clear();
  }

  String getNombre(){
    return _nombre;
  }

  void setNombre(String nombre){
    _nombre = nombre;
  }

  bool serviciosEmpty(){
    return _servicios.isEmpty;
  }

  int getNumServicios(){
    return _servicios.length;
  }

  ServicioTuristico getServicio(int i){
    return _servicios[i];
  }
}