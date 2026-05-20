import 'package:flutter/material.dart';
import 'package:afinador/Afinador/AfinadorBase.dart';
import 'package:afinador/Afinador/AfinadorFlutterPitchDetection.dart';
import 'package:afinador/Afinador/AfinadorHPS.dart';
import 'package:afinador/Afinador/Observador.dart';
import 'package:afinador/Afinador/datosAfinador.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App DS P4',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const PantallaAfinador(title: 'Afinador'),
    );
  }
}

class PantallaAfinador extends StatefulWidget {
  const PantallaAfinador({super.key, required this.title});

  final String title;

  @override
  State<PantallaAfinador> createState() => _PantallaAfinadorState();
}

class _PantallaAfinadorState extends State<PantallaAfinador> implements Observador {
  static const _estrategias = ['FPD (Android)', 'HPS (Android + Linux)'];
  String _currentEstrategia = _estrategias[0];

  AfinadorBase _afinador = AfinadorBase(AfinadorFlutterPitchDetection());

  String _nota      = "";
  double _frecuencia = 0.0;
  double _desviacion = 0.0;
  bool _afinado     = false;
  bool _grabando    = false;

  // Implementación del patrón observador
  @override
  void update(DatosAfinador datos) {
    setState(() {
      _nota       = datos.nota;
      _frecuencia = datos.frecuencia;
      _desviacion = datos.desviacion;
      _afinado    = datos.afinado;
    });
  }

  void _cambiarEstrategia(String? nueva) {
    if (_grabando) return;
    setState(() {
      _currentEstrategia = nueva ?? _estrategias[0];
      _afinador = AfinadorBase(
        nueva == _estrategias[1]
            ? AfinadorHPS()
            : AfinadorFlutterPitchDetection(),
      );
    });
  }

  void _iniciarAfinador() async {
    final permiso = await Permission.microphone.request();

    if (permiso.isGranted) {
      _afinador.addObservador(this);
      _afinador.initRec();
      setState(() => _grabando = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Se necesita permiso de micrófono')),
      );
    }
  }

  void _pararAfinador() {
    _afinador.removeObservador(this);
    _afinador.endRec();
    setState(() {
      _grabando   = false;
      _nota       = "";
      _frecuencia = 0.0;
      _desviacion = 0.0;
      _afinado    = false;
    });
  }

  @override
  void dispose() {
    _pararAfinador();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Afinador')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: _currentEstrategia,
              onChanged: _grabando ? null : _cambiarEstrategia,
              items: _estrategias
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),

            const SizedBox(height: 30),

            Text('Nota: $_nota', style: const TextStyle(fontSize: 32)),
            Text('Frecuencia: ${_frecuencia.toStringAsFixed(2)} Hz'),
            Text('Desviación: ${_desviacion.toStringAsFixed(2)} cents'),
            Text(
              _afinado ? '✅ Afinado' : '❌ Desafinado',
              style: TextStyle(
                color: _afinado ? Colors.green : Colors.red,
                fontSize: 24,
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _grabando ? _pararAfinador : _iniciarAfinador,
              child: Text(_grabando ? 'Parar' : 'Iniciar'),
            ),
          ],
        ),
      ),
    );
  }
}