import 'servicio_turistico.dart';
import 'politica_hotel.dart';

class Hotel implements ServicioTuristico {
  String nombre;
  double precioNoche;
  int noches;
  PoliticaHotel politica;

  Hotel(this.nombre, this.precioNoche, this.noches, this.politica);

  @override
  double getPrecio(){
    return this.politica.calcular(precioNoche, noches);
  }

}