import 'package:flutter/material.dart';

// --- ARQUITECTURA ---
import 'struct_credenciales.dart';
import 'filterManager.dart';
import 'target.dart';
import 'sensorFiltro.dart';
import 'observerPopUp.dart';

// --- FILTROS ---
import 'filterEmail.dart';
import 'filterDomain.dart';
import 'filterExistence.dart';
import 'pwLengthFilter.dart';
import 'pwCapsFilter.dart';
import 'pwCharactersFilter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ej1 P2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Crear Cuenta'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  late FilterManager _manager;
  late SensorFiltro _sensor;

  @override
  void initState() {
    super.initState();

    Target target = Target();
    ObserverPopUp observador = ObserverPopUp(context);

    _sensor = SensorFiltro();
    _sensor.addObserver(observador);
    _manager = FilterManager(target, _sensor);


    //Filtros por orden de ejecución
    _manager.addFilter(FilterEmail());
    _manager.addFilter(FilterDomain());
    _manager.addFilter(FilterExistence());
    _manager.addFilter(PwLengthFilter());
    _manager.addFilter(PwCapsFilter());
    _manager.addFilter(PwCharactersFilter());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _validarCredenciales() {
    Credenciales credenciales = (
      correo: _emailController.text,
      password: _passController.text
    );

    _manager.mandarMensaje(credenciales);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shield, size: 100, color: Colors.deepPurple),
              const SizedBox(height: 30),

              // Input Correo
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),

              // Input Contraseña
              TextField(
                controller: _passController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 40),

              // Botón
              ElevatedButton(
                onPressed: _validarCredenciales,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Validar', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}