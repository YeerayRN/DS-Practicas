import 'dart:ffi';

import 'package:flutter/material.dart';
import 'paquete.dart';
import 'vuelo.dart';
import 'hotel.dart';
import 'lowcost.dart';
import 'business.dart';
import 'solo_alojar.dart';
import 'todo_incluido.dart';

void main() {
  runApp(const AgenciaViajesApp());
}

class AgenciaViajesApp extends StatelessWidget {
  const AgenciaViajesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Servicio Turístico',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GestorPaquetesScreen(),
    );
  }
}

class GestorPaquetesScreen extends StatefulWidget {
  const GestorPaquetesScreen({super.key});

  @override
  State<GestorPaquetesScreen> createState() => _GestorPaquetesScreenState();
}

class _GestorPaquetesScreenState extends State<GestorPaquetesScreen> {
  final Paquete miPaquete = Paquete("Vacaciones de Verano");

  String _politicaVueloSeleccionada = 'LowCost';
  String _politicaHotelSeleccionada = 'Solo Alojamiento';

  final TextEditingController _nochesController = TextEditingController(text: '1');
  final TextEditingController _nombrePaqueteController = TextEditingController(text: 'Vacaciones de Verano');
  final TextEditingController _nombreHotelController = TextEditingController(text: 'Hotel Sol');

  final double PRECIO_BASE_VUELO = 100.0;
  final double PRECIO_BASE_HOTEL = 50.0;

  int _idVuelo = 0;
  @override
  void dispose() {
    _nochesController.dispose();
    _nombrePaqueteController.dispose();
    super.dispose();
  }

  void _addVuelo() {
    final politica = _politicaVueloSeleccionada == 'LowCost'
        ? TarifaLowcost()
        : TarifaBusiness();

    final nuevoVuelo = Vuelo("VUE-${_idVuelo}", PRECIO_BASE_VUELO, politica);
      _idVuelo ++;

    setState(() {
      miPaquete.addServicio(nuevoVuelo);
    });
  }

  void _addHotel() {
    final politica = _politicaHotelSeleccionada == 'Solo Alojamiento'
        ? SoloAlojamiento()
        : TodoIncluido();

    final nombreHotel = _nombreHotelController.text;

    int noches = int.tryParse(_nochesController.text) ?? 0;
    if (noches >= 1) {
      final nuevoHotel = Hotel(nombreHotel, PRECIO_BASE_HOTEL, noches, politica);

      setState(() {
        miPaquete.addServicio(nuevoHotel);
      });
    }
  }

  void _limpiarPaquete() {
    setState(() {
      miPaquete.clearServicios();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor de Paquetes'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nombrePaqueteController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Paquete',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
              onChanged: (value) {
                setState(() {
                  miPaquete.setNombre(value.isEmpty ? "Paquete sin nombre" : value);
                });
              },
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Añadir Vuelo (Precio base: 100€)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            value: _politicaVueloSeleccionada,
                            isExpanded: true,
                            items: ['LowCost', 'Business'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text('Tarifa: $value'),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _politicaVueloSeleccionada = newValue!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _addVuelo,
                          icon: const Icon(Icons.flight),
                          label: const Text('Añadir'),
                        )
                      ],
                    ),
                    const Divider(height: 30),
                    const Text('Añadir Hotel (Precio base: 50€/noche)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _nombreHotelController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'Nombre del hotel',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: DropdownButton<String>(
                            value: _politicaHotelSeleccionada,
                            isExpanded: true,
                            items: ['Solo Alojamiento', 'Todo Incluido'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _politicaHotelSeleccionada = newValue!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _nochesController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Noches',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _addHotel,
                          icon: const Icon(Icons.hotel),
                          label: const Text('Añadir'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Contenido del "${miPaquete.getNombre()}":',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: miPaquete.serviciosEmpty()
                  ? const Center(child: Text('El paquete está vacío.'))
                  : ListView.builder(
                itemCount: miPaquete.getNumServicios(),
                itemBuilder: (context, index) {
                  final servicio = miPaquete.getServicio(index);
                  String titulo = "";
                  String subtitulo = "";

                  if (servicio is Vuelo) {
                    titulo = "Vuelo: ${servicio.getId()}";
                    subtitulo = "Política: ${servicio.getPolitica().runtimeType}";
                  } else if (servicio is Hotel) {
                    titulo = "Hotel: ${servicio.getNombre()}";
                    subtitulo = "${servicio.getNoches()} noches - ${servicio.getPolitica().runtimeType}";
                  }

                  return Card(
                    child: ListTile(
                      leading: Icon(servicio is Vuelo ? Icons.flight_takeoff : Icons.king_bed),
                      title: Text(titulo),
                      subtitle: Text(subtitulo),
                      trailing: Text('${servicio.getPrecio().toStringAsFixed(2)} €',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  );
                },
              ),
            ),
            Card(
              color: Colors.green.shade50,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('PRECIO TOTAL:',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('${miPaquete.getPrecio().toStringAsFixed(2)} €',
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade100,
                          foregroundColor: Colors.red.shade900,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: miPaquete.serviciosEmpty()? null : _limpiarPaquete,
                        icon: const Icon(Icons.delete_sweep),
                        label: const Text('Vaciar Paquete', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}