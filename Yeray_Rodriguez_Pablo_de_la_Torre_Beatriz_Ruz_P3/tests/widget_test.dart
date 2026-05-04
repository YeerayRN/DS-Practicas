import 'dart:ffi';

import 'package:flutter_test/flutter_test.dart';
import 'package:p_3/servicio_turistico.dart';
import 'package:p_3/vuelo.dart';
import 'package:p_3/business.dart';
import 'package:p_3/hotel.dart';
import 'package:p_3/lowcost.dart';
import 'package:p_3/solo_alojar.dart';
import 'package:p_3/lowcost.dart';
import 'package:p_3/business.dart';
import 'package:p_3/paquete.dart';
import 'package:p_3/politica_hotel.dart';
import 'package:p_3/politica_vuelo.dart';
import 'package:p_3/todo_incluido.dart';


void main() {
  const double PRECIO_NOCHE = 50.0;
  const int NOCHES = 5;
    const double PRECIO_BASE = 100.0;

  group('Grupo Políticas de Tarifación', (){
    test("TarifaLowCost añade su recargo de gestión constante al precio base", (){
      final TarifaLowcost tarifa = TarifaLowcost();
      final double costeGestion = tarifa.getCosteGestion();

      final double precioFinal = tarifa.calcular(PRECIO_BASE);

      expect(precioFinal, costeGestion + PRECIO_BASE);
    });
    
    test("TarifaBusiness aplica su multiplicador interno de clase superior correctamente", (){
      final TarifaBusiness tarifa = TarifaBusiness();
      final double multiplicador = tarifa.getMultiplicador();

      final double precioFinal = tarifa.calcular(PRECIO_BASE);

      expect(precioFinal, PRECIO_BASE * multiplicador);
    });
    
    test("SoloAlojamiento calcula el producto exacto de noches por precio", (){
      final SoloAlojamiento alojamiento = SoloAlojamiento();

      final double precioFinal = alojamiento.calcular(PRECIO_NOCHE, NOCHES);

      expect(precioFinal, PRECIO_NOCHE * NOCHES);
    });
    
    test(" RegimenTodoIncluido incorpora su suplemento diario interno alcoste de la estancia.", (){
      final TodoIncluido alojamiento = TodoIncluido();

      final double suplementoDiario = alojamiento.getSuplementoDiario();

      final double precioFinal = alojamiento.calcular(PRECIO_NOCHE, NOCHES);
      
      expect(precioFinal, (PRECIO_NOCHE + suplementoDiario) * NOCHES);
    });
  });
  
  group('Grupo Servicios Individuales', () {
    test("El constructor de Vuelo lanza una excepción ante un precio base negativo", () {
      final politica = TarifaLowcost();

      expect(
            () => Vuelo("VUE-001", -2.0, politica),
        throwsA(isA<ArgumentError>()),
      );

    });

    test("No se permiten reservas de hoteles de 0 o menos noches", () {
      final SoloAlojamiento politica = SoloAlojamiento();

      expect(
            () => Hotel("HOT-001", 10, 0, politica),
        throwsA(isA<ArgumentError>()),
      );
    });


    test("El método getPrecio de Vuelo delega el cálculo en su política asignada", () {
      final TarifaLowcost politica1 = TarifaLowcost();
      final TarifaBusiness politica2 = TarifaBusiness();

      final precio1 = Vuelo("VUE-001", PRECIO_BASE, politica1).getPrecio();
      final precio2 = Vuelo("VUE-002", PRECIO_BASE,politica2).getPrecio();

      expect(precio1, isNot(equals(precio2)));
    });

    test("El método getPrecio de Hotel retorna el valor procesado por su política de régimen", (){
      final SoloAlojamiento politica1 = SoloAlojamiento();
      final TodoIncluido politica2 = TodoIncluido();

      final double suplementoDiario = politica2.getSuplementoDiario();

      final precioFinal1 = Hotel("HOT-001", PRECIO_NOCHE, NOCHES, politica1).getPrecio();
      final precioFinal2 = Hotel("HOT-002", PRECIO_NOCHE, NOCHES, politica2).getPrecio();

      expect(precioFinal1, PRECIO_NOCHE * NOCHES);
      expect(precioFinal2, (PRECIO_NOCHE+suplementoDiario) * NOCHES);
    });
  });
  
  group("Grupo Asignación de paquetes", (){
    test("Un paquete recién instanciado sin servicios devuelve un precio total de 0", (){
      final Paquete paquete = Paquete("PAQ-001");

      double precio = paquete.getPrecio();

      expect(precio, 0.0);
    });
    
    test("El método getPrecio de Paquete realiza la suma aritmética de todos sus componentes directos", (){
      final SoloAlojamiento politicaHotel1 = SoloAlojamiento();
      final TodoIncluido politicaHotel2 = TodoIncluido();
      final TarifaLowcost politicaVuelo1 = TarifaLowcost();
      final TarifaBusiness politicaVuelo2 = TarifaBusiness();

      final suplementoDiario = politicaHotel2.getSuplementoDiario();
      final costeGestion = politicaVuelo1.getCosteGestion();
      final multiplicador = politicaVuelo2.getMultiplicador();

      final List<ServicioTuristico> servicios = [Hotel("HOT-001", PRECIO_NOCHE, NOCHES, politicaHotel1),
                                                 Hotel("HOT-002", PRECIO_NOCHE, NOCHES, politicaHotel2),
                                                 Vuelo("VUE-001", PRECIO_BASE, politicaVuelo1),
                                                 Vuelo("VUE-002", PRECIO_BASE, politicaVuelo2)
                                                ];

      Paquete paquete = Paquete("PAQ-001");
      for(int i = 0; i < servicios.length; i++){
        paquete.addServicio(servicios[i]);
      }


      double precioFinal = 0;
      for(int i = 0; i < servicios.length; i++){
        precioFinal += servicios[i].getPrecio();
      }

      expect(paquete.getPrecio(), precioFinal);
    });
    
    test("La estructura recursiva permite que un paquete raíz sume recursivamente el importe de paquetes anidados", (){
      final SoloAlojamiento politicaHotel1 = SoloAlojamiento();
      final TodoIncluido politicaHotel2 = TodoIncluido();
      final TarifaLowcost politicaVuelo1 = TarifaLowcost();
      final TarifaBusiness politicaVuelo2 = TarifaBusiness();

      final suplementoDiario = politicaHotel2.getSuplementoDiario();
      final costeGestion = politicaVuelo1.getCosteGestion();
      final multiplicador = politicaVuelo2.getMultiplicador();

      final List<ServicioTuristico> servicios = [Hotel("HOT-001", PRECIO_NOCHE, NOCHES, politicaHotel1),
                                                 Hotel("HOT-002", PRECIO_NOCHE, NOCHES, politicaHotel2),
                                                 Vuelo("VUE-001", PRECIO_BASE, politicaVuelo1),
                                                 Vuelo("VUE-002", PRECIO_BASE, politicaVuelo2)
                                               ];

      double precioFinal = 0.0;

      Paquete paquete1 = Paquete("PAQ-001");
      for(int i = 0; i < 2; i++){
        paquete1.addServicio(servicios[i]);
        precioFinal += servicios[i].getPrecio();
      }

      Paquete paquete2 = Paquete("PAQ-002");
      for(int i = 2; i < servicios.length; i++){
        paquete1.addServicio(servicios[i]);
        precioFinal += servicios[i].getPrecio();
      }

      paquete1.addServicio(paquete2);

      expect(paquete1.getPrecio(), precioFinal);
    });
    
    test("La modificación de la política de un servicio contenido actualiza el precio total del paquete raíz", (){
      final TarifaLowcost politicaVuelo1 = TarifaLowcost();
      final TarifaBusiness politicaVuelo2 = TarifaBusiness();
      final multiplicador = politicaVuelo2.getMultiplicador();

      Vuelo vuelo = Vuelo("VUE-001", PRECIO_BASE, politicaVuelo1);
      Paquete paquete = Paquete("PAQ-001");

      paquete.addServicio(vuelo);

      vuelo.setPolitica(politicaVuelo2);

      expect(paquete.getPrecio(), PRECIO_BASE * multiplicador);
    });
  });
}