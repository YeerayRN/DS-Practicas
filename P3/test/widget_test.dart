import 'package:flutter_test/flutter_test.dart';
import 'package:practica3ds/vuelo.dart';
import 'package:practica3ds/solo_alojar.dart';
import 'package:practica3ds/lowcost.dart';
import 'package:practica3ds/business.dart';



void main() {
  group('Grupo Servicios Individuales', () {

    test("El constructor de Vuelo lanza una excepción ante un precio base negativo", () {

      final politica = TarifaLowCost();

      expect(
            () => Vuelo("VUE-001", -2.0, politica),
        throwsA(isA<ArgumentError>()),
      );

    });

    test("No se permiten reservas de hoteles de 0 o menos noches", () {

      final politica = SoloAlojamiento();

      expect(
            () => Hotel("HOT-001", 0, politica),
        throwsA(isA<ArgumentError>()),
      );

    });


    test("getPrecio de Vuelo delega el cálculo en su política asignada", () {

      final politica1 = TarifaLowCost();
      final politica2 = TarifaBusiness();

      final precio1 = Vuelo("VUE-001", 50, politica1).getPrecio();
      final precio2 = Vuelo("VUE-002",50,politica2).getPrecio();

      expect(precio1, isNot(equals(precio2)));
      );

    });

  });
}