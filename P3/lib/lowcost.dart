import 'politica_vuelo.dart';

class TarifaLowcost implements PoliticaVuelo {
    static const double _gestion = 50;

    @override
    double calcular(double base) => base + _gestion;

    double getCosteGestion() => _gestion;
}