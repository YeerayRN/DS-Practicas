import 'package:afinador/Afinador/datosAfinador.dart';
import 'package:flutter/material.dart';
import 'package:afinador/Afinador/AfinadorBase.dart';
import 'package:afinador/Afinador/AfinadorFlutterPitchDetection.dart';
import 'package:afinador/Afinador/AfinadorHPS.dart';
import 'package:afinador/Acordes/GestorAcordes.dart';
import 'package:afinador/Acordes/Acorde.dart';
import 'package:afinador/Afinador/Observador.dart';
import 'package:afinador/pantallaRegistro.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:math' as math;

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

class _PantallaAfinadorState extends State<PantallaAfinador> implements Observador{
  static const _estrategias = ['FPD (Móvil)', 'HPS (Móvil y PC)'];
  String _currentEstrategia = _estrategias[0];

  AfinadorBase _afinador = AfinadorBase(AfinadorFlutterPitchDetection());

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

    final Map<String, String>? data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PantallaRegistro()),
    );

    String? nombre = data?['nombre']?? "Invitado";
    String? ip = data?['ip']?? "127.0.0.1";

    setState(() => _iniciandoSesion = true);

    try {
      final gestor = GestorAcordes(usuario: nombre, ip: ip);
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

  @override
  void update(DatosAfinador datos){
    setState(() {
      _nota       = datos.nota;
      _frecuencia = datos.frecuencia;
      _desviacion = datos.desviacion;
      _afinado    = datos.afinado;
    });
  }

  void _iniciarAfinador() async {
    final permiso = await Permission.microphone.request();
    if (permiso.isGranted) {
      _afinador.addObservador(this);
      _afinador.initRec();
      setState(() => _grabando = true);
    } else {
      if (!mounted) return;
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

  //Cuadro de diálogo para añadir un acorde
  void _mostrarDialogoNuevoAcorde() {
    final nombreCtrl = TextEditingController();
    final cuerdasCtrls = List.generate(6, (_) => TextEditingController(text: "0"));
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

                      List<int> trastes = cuerdasCtrls.map((c) => int.tryParse(c.text) ?? -1).toList();

                      Acorde nuevoAcorde = Acorde(
                          nombre,
                          trastes[0], trastes[1], trastes[2],
                          trastes[3], trastes[4], trastes[5]
                      );

                      try {
                        await _gestorAcordes!.agregar(nuevoAcorde);
                        if (!mounted) return;
                        Navigator.pop(context);
                        setState(() {});
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

  void _mostrarDialogoEditarAcorde(Acorde acorde) {
    final nombreCtrl = TextEditingController(text: acorde.nombre);
    final cuerdasCtrls = [
      TextEditingController(text: acorde.cuerda1.toString()),
      TextEditingController(text: acorde.cuerda2.toString()),
      TextEditingController(text: acorde.cuerda3.toString()),
      TextEditingController(text: acorde.cuerda4.toString()),
      TextEditingController(text: acorde.cuerda5.toString()),
      TextEditingController(text: acorde.cuerda6.toString()),
    ];
    bool guardando = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Editar Acorde'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nombreCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del acorde',
                        prefixIcon: Icon(Icons.music_note),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Trastes (-1 = no suena, 0 = al aire)',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 10),
                    Row(
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

                    List<int> trastes = cuerdasCtrls
                        .map((c) => int.tryParse(c.text) ?? -1)
                        .toList();

                    Acorde editado = Acorde(
                      nombre,
                      trastes[0], trastes[1], trastes[2],
                      trastes[3], trastes[4], trastes[5],
                    );

                    try {
                      await _gestorAcordes!.editar(acorde.id!, editado);
                      if (!mounted) return;
                      Navigator.pop(context);
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Acorde actualizado')),
                      );
                    } catch (e) {
                      setStateDialog(() => guardando = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  void _eliminarAcorde(Acorde acorde) async {
    try {
      await _gestorAcordes!.eliminar(acorde);
      setState(() {});
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
                      value: _currentEstrategia,
                      onChanged: _grabando ? null : _cambiarEstrategia,
                      items: _estrategias
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                    ),

                    const SizedBox(height: 20),

                    Text(
                        _nota.isEmpty ? '--' : _nota,
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)
                    ),
                    Text('Frecuencia: ${_frecuencia.toStringAsFixed(2)} Hz'),
                    Text('Desviación: ${_desviacion.toStringAsFixed(2)} cents'),

                    const SizedBox(height: 25),

                    // AQUÍ SE HA INTEGRADO LA AGUJA VISUAL EN LUGAR DEL TEXTO ESTATICO
                    AfinadorAguja(desviacion: _desviacion, afinado: _afinado),

                    const SizedBox(height: 25),

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

                    // SECCIÓN DE ACORDES
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

                      if (_gestorAcordes!.getAcordes().isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('Aún no tienes acordes guardados.', style: TextStyle(color: Colors.grey)),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _gestorAcordes!.getAcordes().length,
                          itemBuilder: (context, index) {
                            final acorde = _gestorAcordes!.getAcordes()[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                leading: const CircleAvatar(child: Icon(Icons.queue_music)),
                                title: Text(acorde.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('Trastes: [ ${acorde.cuerda1}, ${acorde.cuerda2}, ${acorde.cuerda3}, ${acorde.cuerda4}, ${acorde.cuerda5}, ${acorde.cuerda6} ]'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent),
                                      onPressed: () => _mostrarDialogoEditarAcorde(acorde),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                      onPressed: () => _eliminarAcorde(acorde),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// COMPONENTE VISUAL: WIDGET DE LA AGUJA DEL AFINADOR
class AfinadorAguja extends StatelessWidget {
  final double desviacion;
  final bool afinado;

  const AfinadorAguja({super.key, required this.desviacion, required this.afinado});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(280, 120),
      painter: _AgujaPainter(desviacion: desviacion, afinado: afinado),
    );
  }
}

class _AgujaPainter extends CustomPainter {
  final double desviacion;
  final bool afinado;

  _AgujaPainter({required this.desviacion, required this.afinado});

  @override
  void paint(Canvas canvas, Size size) {
    final centro = Offset(size.width / 2, size.height - 10);
    final radio = size.width * 0.45;

    // 1. Dibujar el arco de fondo
    final pinturaArco = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    canvas.drawArc(
      Rect.fromCircle(center: centro, radius: radio),
      math.pi, // Comienza a la izquierda (180 grados)
      math.pi, // Recorre un semicírculo completo
      false,
      pinturaArco,
    );

    // 2. Dibujar la marca central (Punto de afinación perfecta)
    final pinturaMarcaCentral = Paint()
      ..color = afinado ? Colors.greenAccent : Colors.white38
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawLine(
      Offset(centro.dx, centro.dy - radio - 5),
      Offset(centro.dx, centro.dy - radio + 10),
      pinturaMarcaCentral,
    );

    // 3. Calcular la inclinación de la aguja basándonos en la desviación
    // Acotamos la desviación entre -50 y 50 cents (límites estándar de afinación)
    double desviacionClamped = desviacion.clamp(-50.0, 50.0);

    // Ángulo máximo de inclinación hacia los lados (60 grados = pi / 3 radianes)
    double deflexionMaxima = math.pi / 3;

    // El centro (0 cents) vertical es -pi/2 en el sistema de coordenadas de Flutter
    double anguloDestino = -math.pi / 2 + (desviacionClamped / 50.0) * deflexionMaxima;

    // 4. Dibujar la aguja reactiva
    final pinturaAguja = Paint()
      ..color = afinado ? Colors.greenAccent : Colors.redAccent
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    final finAguja = Offset(
      centro.dx + (radio * 0.95) * math.cos(anguloDestino),
      centro.dy + (radio * 0.95) * math.sin(anguloDestino),
    );

    canvas.drawLine(centro, finAguja, pinturaAguja);

    // 5. Dibujar el pivote (punto de anclaje de la aguja)
    final pinturaPivote = Paint()
      ..color = afinado ? Colors.greenAccent : Colors.redAccent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(centro, 6.0, pinturaPivote);
  }

  @override
  bool shouldRepaint(covariant _AgujaPainter oldDelegate) {
    return oldDelegate.desviacion != desviacion || oldDelegate.afinado != afinado;
  }
}