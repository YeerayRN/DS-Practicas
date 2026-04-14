import 'servicio_turistico.dart';

class Paquete implements ServicioTuristico{
  String nombre;
  List<ServicioTuristico> servicios;

  Paquete(this.nombre, this.servicios);

  @override
  double getPrecio(){
    double total = 0.0;

    for(ServicioTuristico s in servicios){
      total += s.getPrecio();
    }

    return total;
  }
}