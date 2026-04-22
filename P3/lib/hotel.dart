import 'servicio_turistico.dart';
import 'politica_hotel.dart';

class Hotel implements ServicioTuristico {
  String _nombre;
  double _precioNoche;
  int _noches;
  PoliticaHotel _politica;

  Hotel(this._nombre, this._precioNoche, this._noches, this._politica){
    if (_noches <= 0){
      throw ArgumentError('El número de noches debe ser > 0');
    }
  }

  @override
  double getPrecio(){
    return this._politica.calcular(_precioNoche, _noches);
  }

  String getNombre(){
    return _nombre;
  }

  PoliticaHotel getPolitica(){
    return _politica;
  }

  int getNoches(){
    return _noches;
  }
}