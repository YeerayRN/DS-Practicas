import 'politica_vuelo.dart';
import 'servicio_turistico.dart';

class Vuelo implements ServicioTuristico {
  String id;
  double precioBase;
  PoliticaVuelo politica;

  Vuelo(this.id, this.precioBase, this.politica);

  @override
  double getPrecio(){
    return politica.calcular(precioBase);
  }
}