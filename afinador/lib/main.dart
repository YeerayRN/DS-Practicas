import 'package:flutter/material.dart';
import 'package:afinador/Afinador/AfinadorBase.dart';
import 'package:afinador/Afinador/AfinadorFlutterPitchDetection.dart';
import 'package:afinador/Afinador/AfinadorHPS.dart';
import 'package:afinador/Acordes/GestorAcordes.dart';
import 'package:afinador/Acordes/Acorde.dart'; // Importante importar el modelo
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
      if (!mounted) return;
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
      if (!mounted) return;
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

  // --- NUEVA FUNCIÓN: Cuadro de diálogo para añadir un acorde ---
  void _mostrarDialogoNuevoAcorde() {
    final nombreCtrl = TextEditingController();
    // Generamos 6 controladores, uno para cada cuerda, inicializados a -1 (muteada)
    final cuerdasCtrls = List.generate(6, (_) => TextEditingController(text: "-1"));
    bool guardando = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Añadir Nuevo Acorde'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nombreCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del acorde',
                        hintText: 'Ej: Do Mayor',
                        prefixIcon: Icon(Icons.music_note),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Trastes (-1 = no suena, 0 = al aire)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 10),
                    // Fila con los 6 inputs para las cuerdas
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: TextField(
                              controller: cuerdasCtrls[index],
                              keyboardType: const TextInputType.numberWithOptions(signed: true),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                labelText: 'C${index + 1}',
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: guardando ? null : () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                guardando
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          final nombre = nombreCtrl.text.trim();
                          if (nombre.isEmpty) return;

                          setStateDialog(() => guardando = true);

                          // Extraemos y parseamos los valores de los 6 TextFields
                          List<int> trastes = cuerdasCtrls.map((c) => int.tryParse(c.text) ?? -1).toList();

                          Acorde nuevoAcorde = Acorde(
                            nombre, 
                            trastes[0], trastes[1], trastes[2], 
                            trastes[3], trastes[4], trastes[5]
                          );

                          try {
                            // Llamada a la API a través del gestor
                            await _gestorAcordes!.agregar(nuevoAcorde);
                            if (!mounted) return;
                            Navigator.pop(context); // Cerramos el modal
                            setState(() {}); // Refrescamos la pantalla principal para ver el acorde
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Acorde guardado con éxito')));
                          } catch (e) {
                            setStateDialog(() => guardando = false);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                          }
                        },
                        child: const Text('Guardar'),
                      ),
              ],
            );
          }
        );
      },
    );
  }

  void _eliminarAcorde(Acorde acorde) async {
    try {
      await _gestorAcordes!.eliminar(acorde);
      setState(() {}); // Refrescamos la lista local tras borrar
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Acorde eliminado')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
    }
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
                      label: const Text('Registrarse', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      onPressed: _abrirRegistro,
                    ),
                  ),
        ],
      ),
      // Envolvemos todo en SingleChildScrollView para poder scrollear si hay muchos acordes
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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

            // SECCIÓN DE ACORDES (Solo visible si hay un usuario logueado)
            if (_gestorAcordes != null) ...[
              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 10),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tus Acordes',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                  ),
                  ElevatedButton.icon(
                    onPressed: _mostrarDialogoNuevoAcorde,
                    icon: const Icon(Icons.add),
                    label: const Text('Añadir'),
                  ),
                ],
              ),
              
              const SizedBox(height: 10),
              
              // Renderizamos la lista de acordes
              if (_gestorAcordes!.getAcordes().isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('Aún no tienes acordes guardados.', style: TextStyle(color: Colors.grey)),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // Desactiva el scroll interno de la lista para usar el del SingleChildScrollView
                  itemCount: _gestorAcordes!.getAcordes().length,
                  itemBuilder: (context, index) {
                    final acorde = _gestorAcordes!.getAcordes()[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.queue_music)),
                        title: Text(acorde.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Trastes: [ ${acorde.cuerda1}, ${acorde.cuerda2}, ${acorde.cuerda3}, ${acorde.cuerda4}, ${acorde.cuerda5}, ${acorde.cuerda6} ]'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () => _eliminarAcorde(acorde),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ],
        ),
      ),
    );
  }
}