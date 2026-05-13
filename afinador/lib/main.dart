import 'package:flutter/material.dart';
import 'package:afinador/Afinador/AfinadorBase.dart';
import 'package:afinador/Afinador/AfinadorFlutterPitchDetection.dart';
import 'package:afinador/Afinador/AfinadorHPS.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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

class _PantallaAfinadorState extends State<PantallaAfinador> {
  static const _estrategias = ['FlutterPitchDetection', 'HPS'];
  String _currentEstrategia = _estrategias[0];

  AfinadorBase _afinador = AfinadorBase(AfinadorFlutterPitchDetection());

  Timer? _timer;
  String _nota = "";
  double _frecuencia = 0.0;
  double _desviacion = 0.0;
  bool _afinado = false;
  bool _grabando = false;

  void _cambiarEstrategia(String? nueva){
    if(!(_grabando && nueva == null)){
      setState(() {
        _currentEstrategia = nueva ?? _estrategias[0];

        _afinador = AfinadorBase(
          nueva == _estrategias[1]
              ? AfinadorHPS()
              : AfinadorFlutterPitchDetection(),
        );
      });
    }
  }

  void _iniciarAfinador() async{
    final permisoMicro = await Permission.microphone.request();

    if(permisoMicro.isGranted){
      _afinador.initRec();
      setState(() => _grabando = true);

      _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        setState(() {
          _nota       = _afinador.getNota();
          _frecuencia = _afinador.getFrecuencia();
          _desviacion = _afinador.getDesviacion();
          _afinado    = _afinador.isAfinado();
        });
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Se necesita permiso de micrófono')),
      );
    }
  }

  void _pararAfinador() {
    _timer?.cancel();
    _timer = null;
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
            // Selector de estrategia
            DropdownButton<String>(
              value: _currentEstrategia,
              // Se deshabilita mientras graba
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

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _grabando ? _pararAfinador : _iniciarAfinador,
                  child: Text(_grabando ? 'Parar': 'Iniciar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
