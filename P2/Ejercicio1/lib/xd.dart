import 'package:flutter/material.dart';
import 'observer.dart';
import 'observerPopUp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(title: 'Womp Nigga AI Cheats'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});
  final String title;
  final Observer observador = ObserverPopUp();


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many pens:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}


import 'filterChain.dart';
import 'struct_credenciales.dart';
import 'target.dart';
import 'sensorFiltro.dart';

class FilterManager {
  late FilterChain _filterChain;

  FilterManager(Target target, SensorFiltro sensor) {
    _filterChain = FilterChain(target, sensor);
  }

  void addFilter(dynamic filter) {
    _filterChain.addFilter(filter);
  }

  void mandarMensaje(Credenciales mensaje) {
    _filterChain.ejecutar(mensaje);
  }
}


import 'struct_credenciales.dart';
import 'filter.dart';
import 'target.dart';
import 'sensorFiltro.dart';

class FilterChain{
  List<Filter> _filters = [];
  Target _target;
  SensorFiltro _sensor;

  FilterChain(this._target, this._sensor);

  void setTarget(Target target){
    _target = target;
  }

  void addFilter(Filter filter){
    _filters.add(filter);
  }
  
  @override
  void ejecutar(Credenciales mensaje){

    for(int i = 0; i < _filters.length; i++){
      bool result = _filters[i].ejecutar(mensaje);

      if(!result){
        _sensor.setError(_filters[i].msgerror());
        return;
      }
    }
    
    _target.ejecutar(mensaje);
  }
}


import 'filter.dart';
import 'struct_credenciales.dart';

class FilterDomain implements Filter {
  static const List<String> validDomains = ['@gmail.com', '@hotmail.com'];

  @override
  bool ejecutar(Credenciales credenciales) {

    for (String domain in validDomains) {
      if (credenciales.correo.endsWith(domain)) {
        return true;
      }
    }
    return false;
  }

  @override
    String msgerror(){
        return "Dominio no válido. El correo debe pertenecer a los dominios \'@gmail.com\' o \'@hotmail.com\'.";
    }
}


import 'filter.dart';
import 'struct_credenciales.dart';

class FilterEmail implements Filter{
  static const String specialCharacters = "!#\$%&'()*+,-./:;<=>?@[\\]^{|}~`";

  @override
  bool ejecutar(Credenciales credenciales){
    String nombre = credenciales.correo.split("@")[0];

    if(credenciales.correo.contains("@") && nombre.isNotEmpty && '@'.allMatches(credenciales.correo).length == 1){
      
      for (int i = 0; i < nombre.length; i++) {
        if (specialCharacters.contains(nombre[i])) {
          return false;
        }
      }

      return true;
    }
    
    return false;
  }

  String msgerror(){
    return "El correo electrónico no es válido. Introduzca un formato de correo válido.";
  }
}

import 'filter.dart';
import 'struct_credenciales.dart';

class PwCapsFilter implements Filter {
  static final _regexMayus = RegExp(r'[A-Z]');
  static final _regexMinus = RegExp(r'[a-z]');

  @override
  bool ejecutar(Credenciales credenciales) {
    final tieneMayus = _regexMayus.hasMatch(credenciales.password);
    final tieneMinuscula = _regexMinus.hasMatch(credenciales.password);

    return (tieneMayus && tieneMinuscula);
  }

  @override
  String msgerror(){
    return "Contraseña no válida: debe contener al menos una letra minúscula y otra mayúscula.";
  }
}

import 'filter.dart';
import 'struct_credenciales.dart';

class PwCharactersFilter implements Filter {
  static const String _specialCharacters = "!#\$%&'()*+,-./:;<=>?@[\\]^_{|}~`";

  @override
  bool ejecutar(Credenciales credenciales) {
    for (int i = 0; i < credenciales.password.length; i++) {
      if (_specialCharacters.contains(credenciales.password[i])) {
        return true;
      }
    }
    return false;
  }

  @override
  String msgerror(){
    return "Comprobación de caracteres especiales incorrecta. Por favor, añada algunos a su contraseña.";
  }
}


import 'filter.dart';
import 'struct_credenciales.dart';

class PwLengthFilter implements Filter {
  static const int _minLength = 10;
  static const int _maxLength = 128;
  String _error = "";

  @override
  bool ejecutar(Credenciales mensaje) {

    if (mensaje.password.isEmpty) {
      _error = "La contraseña no puede estar vacía";
      return false;
    }
    
    if (mensaje.password.length < _minLength) {
      _error = 'La contraseña debe tener al menos $_minLength caracteres';
      return false;
    }
    
    if (mensaje.password.length > _maxLength) {
      _error = "La contraseña no puede exceder $_maxLength caracteres";
      return false;
    }

    return true;
  }

  @override
  String msgerror(){
    return _error;
  }
}

import 'struct_credenciales.dart';

abstract class Filter{
  bool ejecutar(Credenciales mensaje);
  String msgerror();
}

import 'filterChain.dart';
import 'struct_credenciales.dart';
import 'target.dart';
import 'sensorFiltro.dart';

class FilterManager {
  late FilterChain _filterChain;

  FilterManager(Target target, SensorFiltro sensor) {
    _filterChain = FilterChain(target, sensor);
  }

  void addFilter(dynamic filter) {
    _filterChain.addFilter(filter);
  }

  void mandarMensaje(Credenciales mensaje) {
    _filterChain.ejecutar(mensaje);
  }
}


abstract class Observer {
  String update(String mensaje);
}

import 'observer.dart';

class ObserverPopUp implements Observer{

  ObserverPopUp();
  
  String update(String mensaje){
    return mensaje;
  }
}

import 'filter.dart';
import 'struct_credenciales.dart';

class PwCapsFilter implements Filter {
  static final _regexMayus = RegExp(r'[A-Z]');
  static final _regexMinus = RegExp(r'[a-z]');

  @override
  bool ejecutar(Credenciales credenciales) {
    final tieneMayus = _regexMayus.hasMatch(credenciales.password);
    final tieneMinuscula = _regexMinus.hasMatch(credenciales.password);

    return (tieneMayus && tieneMinuscula);
  }

  @override
  String msgerror(){
    return "Contraseña no válida: debe contener al menos una letra minúscula y otra mayúscula.";
  }
}

import 'filter.dart';
import 'struct_credenciales.dart';

class PwCharactersFilter implements Filter {
  static const String _specialCharacters = "!#\$%&'()*+,-./:;<=>?@[\\]^_{|}~`";

  @override
  bool ejecutar(Credenciales credenciales) {
    for (int i = 0; i < credenciales.password.length; i++) {
      if (_specialCharacters.contains(credenciales.password[i])) {
        return true;
      }
    }
    return false;
  }

  @override
  String msgerror(){
    return "Comprobación de caracteres especiales incorrecta. Por favor, añada algunos a su contraseña.";
  }
}


import 'filter.dart';
import 'struct_credenciales.dart';

class PwLengthFilter implements Filter {
  static const int _minLength = 10;
  static const int _maxLength = 128;
  String _error = "";

  @override
  bool ejecutar(Credenciales mensaje) {

    if (mensaje.password.isEmpty) {
      _error = "La contraseña no puede estar vacía";
      return false;
    }
    
    if (mensaje.password.length < _minLength) {
      _error = 'La contraseña debe tener al menos $_minLength caracteres';
      return false;
    }
    
    if (mensaje.password.length > _maxLength) {
      _error = "La contraseña no puede exceder $_maxLength caracteres";
      return false;
    }

    return true;
  }

  @override
  String msgerror(){
    return _error;
  }
}

import 'observer.dart';

abstract class Sensor {
  void addObserver(Observer observador);

  void removeObserver(Observer observador);

  void notifyObservers();
}

import 'sensor.dart';
import 'observer.dart';

class SensorFiltro implements Sensor {
  List<Observer> _observadores = [];
  String _error = "";

  @override
  void addObserver(Observer observador){
    _observadores.add(observador);
  }

  @override
  void removeObserver(Observer observador){
    Type tipo = observador.runtimeType;

    _observadores.removeWhere((item) => item.runtimeType == tipo);
  }

  @override
  void setError(String newError){
    _error = newError;
  }

  @override
  void notifyObservers(){
    for(Observer i in _observadores){
      i.update(_error);
    }
  }
}

typedef Credenciales = ({
    String correo, 
    String password
});

import 'struct_credenciales.dart';

class Target {
  void ejecutar(Credenciales mensaje){
    print("El correo ${mensaje.correo} ha sido validado.");
    print("La contraseña ${mensaje.password} ha sido validada.");
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Womp Nigga AI Cheats'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many pens:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
