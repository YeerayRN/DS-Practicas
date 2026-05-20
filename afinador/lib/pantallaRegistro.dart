import 'package:flutter/material.dart';

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _controllerNombre = TextEditingController();
  final _controllerIp = TextEditingController();
  bool _cargando = false;
  String? _error;

  void _confirmar() {
    final nombre = _controllerNombre.text.trim();
    if (nombre.isEmpty) {
      setState(() => _error = "Introduce un nombre de usuario");
      return;
    }

    String? ip = _controllerIp.text.trim();
    if(ip.isEmpty){
      ip = "127.0.0.1";
    }

    Map<String, String> data = {"nombre": nombre, "ip": ip};
    // Mostramos el indicador de carga un instante antes de volver
    setState(() => _cargando = true);
    
    // Devolvemos el nombre introducido a main.dart
    Navigator.pop(context, data);
  }

  @override
  void dispose() {
    _controllerNombre.dispose();
    _controllerIp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar sesión'),
        // Usamos los mismos colores de contraste que en main.dart
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: Center(
        // SingleChildScrollView evita el error visual si se abre el teclado del móvil
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono visual para rellenar la pantalla
              Icon(
                Icons.account_circle,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 40),

              TextField(
                controller: _controllerNombre,
                decoration: InputDecoration(
                  labelText: 'Nombre de usuario',
                  errorText: _error,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
                ),
                onSubmitted: (_) => _confirmar(),
              ),
              const SizedBox(height: 30),

              TextField(
                controller: _controllerIp,
                decoration: InputDecoration(
                  labelText: 'IP del servidor (Déjala en blanco para localhost)',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lan),
                ),
                onSubmitted: (_) => _confirmar(),
              ),
              const SizedBox(height: 30),
              
              _cargando?
                  const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: _confirmar,
                      icon: const Icon(Icons.login),
                      label: const Text(
                        'Entrar',
                        style: TextStyle(fontSize: 18),
                      ),
                      // Mismo estilo y padding que el botón de main.dart
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}