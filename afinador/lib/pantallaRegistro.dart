import 'package:flutter/material.dart';
import 'package:afinador/GestorUsuarios.dart'; // Ajusta la ruta si GestorUsuarios está en otra carpeta

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final TextEditingController _nombreController = TextEditingController();
  final GestorUsuarios _gestorUsuarios = GestorUsuarios();
  
  bool _cargando = false;

  void _intentarRegistrar() async {
    String nombre = _nombreController.text.trim();
    
    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, introduce un nombre')),
      );
      return;
    }

    setState(() => _cargando = true);

    int? nuevoId = await _gestorUsuarios.registrarUsuario(nombre);

    setState(() => _cargando = false);

    if (nuevoId != null) {
      // Si tenemos contexto montado, mostramos éxito y cerramos la pantalla
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso. ¡Bienvenido!')),
      );

      // El pop devuelve los datos a la pantalla anterior (Afinador)
      Navigator.pop(context, {
        'id': nuevoId,
        'nombre': nombre
      });
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al conectar con el servidor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 20),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre de usuario',
                border: OutlineInputBorder(),
              ),
              enabled: !_cargando,
            ),
            const SizedBox(height: 20),
            _cargando
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    onPressed: _intentarRegistrar,
                    label: const Text('Crear Usuario'),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }
}