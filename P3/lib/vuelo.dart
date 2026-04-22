import 'politica_vuelo.dart';
import 'servicio_turistico.dart';

class Vuelo implements ServicioTuristico {
  String _id;
  double _precioBase;
  PoliticaVuelo _politica;

  Vuelo(this._id, this._precioBase, this._politica){
    if(_precioBase < 0){
      throw ArgumentError('El precio base no puede ser < 0');
    }
  }

  @override
  double getPrecio(){
    return _politica.calcular(_precioBase);
  }

  String getId(){
    return _id;
  }

  PoliticaVuelo getPolitica(){
    return _politica;
  }

  void setPolitica(PoliticaVuelo politica){
    _politica = politica;
  }
}