import 'politica_hotel.dart';

class TodoIncluido implements PoliticaHotel{
  static const double _suplementoDiario = 30.0; 

  @override
  double calcular(double precioNoche, int noches) {
    return (precioNoche + _suplementoDiario) * noches;
  }
}