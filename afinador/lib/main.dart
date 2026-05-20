import 'package:flutter/material.dart';
import 'package:afinador/Afinador/AfinadorBase.dart';
import 'package:afinador/Afinador/AfinadorFlutterPitchDetection.dart';
import 'package:afinador/Afinador/AfinadorHPS.dart';
import 'package:afinador/Acordes/GestorAcordes.dart';
import 'package:afinador/pantallaRegistro.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App DS P4',
      // Activamos el modo oscuro ajustando el brillo en el ColorScheme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
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
  String _nota      = "";
  double _frecuencia = 0.0;
  double _desviacion = 0.0;
  bool _afinado     = false;
  bool _grabando    = false;

  GestorAcordes? _gestorAcordes;
  String _nombreUsuario = "Invitado";
  bool _iniciandoSesion = false;

  Future<void> _abrirRegistro() async {
    if (_grabando) _pararAfinador();

    final String? nombre = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PantallaRegistro()),
    );

    if (nombre == null) return; 

    setState(() => _iniciandoSesion = true);

    try {
      final gestor = GestorAcordes(usuario: nombre);
      await gestor.iniciarSesion(nombre);

      setState(() {
        _gestorAcordes  = gestor;
        _nombreUsuario  = nombre;
        _iniciandoSesion = false;
      });
    } catch (e) {
      setState(() => _iniciandoSesion = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión: $e')),
      );
    }
  }

  void _cambiarEstrategia(String? nueva) {
    if (_grabando) return;
    setState(() {
      _currentEstrategia = nueva ?? _estrategias[0];
      _afinador = AfinadorBase(
        nueva == _estrategias[1] ? AfinadorHPS() : AfinadorFlutterPitchDetection(),
      );
    });
  }

  void _iniciarAfinador() async {
    final permiso = await Permission.microphone.request();
    if (permiso.isGranted) {
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
    } else {
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
      appBar: AppBar(
        title: Text('Afinador - $_nombreUsuario'),
        // Añadimos un color de fondo contrastado para asegurar visibilidad
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        actions: [
          if (_gestorAcordes == null)
            _iniciandoSesion
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextButton.icon(
                      icon: const Icon(Icons.person_add),
                      label: const Text(
                        'Registrarse',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      onPressed: _abrirRegistro,
                    ),
                  ),
        ],
      ),
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
                color: _afinado ? Colors.greenAccent : Colors.redAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _grabando ? _pararAfinador : _iniciarAfinador,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text(
                _grabando ? 'Parar' : 'Iniciar',
                style: const TextStyle(fontSize: 18),
              ),
            ),

            if (_gestorAcordes != null) ...[
              const SizedBox(height: 30),
              Text(
                'Acordes de $_nombreUsuario:',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ..._gestorAcordes!.getAcordes().map(
                    (a) => Text(a.toString()),
              ),
            ],
          ],
        ),
      ),
    );
  }
}