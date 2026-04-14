import 'politica_vuelo.dart';

class TarifaBusiness implements PoliticaVuelo {
    static const double _multiplicador = 2.5; 

    @override
    double calcular(double base) => base * _multiplicador;
}