import 'package:flutter/material.dart';
import 'observer.dart';

class ObserverPopUp implements Observer {
  final BuildContext context;

  ObserverPopUp(this.context);
  
  @override
  String update(String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alerta'),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          )
        ],
      ),
    );
    return mensaje;
  }
}