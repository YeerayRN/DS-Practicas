import 'package:flutter/material.dart';
import 'secret_keeper.dart';
import 'basic_secret_keeper.dart';
import 'strong_prompt_decorator.dart';
import 'keyword_block_decorator.dart';
import 'length_limit_decorator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El Guardián Secreto',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DifficultySelectionScreen(),
    );
  }
}

// Pantalla 1: Selección de dificultad
class DifficultySelectionScreen extends StatelessWidget {
  const DifficultySelectionScreen({super.key});

  SecretKeeper _crearGuardian(String dificultad) {
    const apiKey = 'API'; // Clave API de Gemini
    
    // Nivel Base (Fácil)
    SecretKeeper guardian = BasicSecretKeeper("Pera",apiKey);

    if (dificultad == 'Medio') {
      // Nivel Medio: Básico envuelto con gruñón
      guardian = StrongPromptDecorator(guardian);
    } 
    else if (dificultad == 'Difícil') {
      // Nivel Difícil: Todas las capas envueltas
      guardian = StrongPromptDecorator(guardian);
      guardian = KeywordBlockDecorator(guardian);
      guardian = LengthLimitDecorator(guardian);
    }

    return guardian;
  }

  void _iniciarJuego(BuildContext context, String dificultad) {
    final guardianConfigurado = _crearGuardian(dificultad);

    // Pantalla de chat con el guardián ya montado
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(guardian: guardianConfigurado),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Elige tu desafío')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Intenta descubrir la palabra secreta...',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _iniciarJuego(context, 'Fácil'),
              child: const Text('Nivel Fácil (Ingenuo)'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => _iniciarJuego(context, 'Medio'),
              child: const Text('Nivel Medio (Gruñón)'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[100]),
              onPressed: () => _iniciarJuego(context, 'Difícil'),
              child: const Text('Nivel Difícil (Máxima Seguridad)'),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla 2: El chat
class ChatScreen extends StatefulWidget {
  final SecretKeeper guardian;

  const ChatScreen({super.key, required this.guardian});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _mensajes = [];
  bool _estaPensando = false;

  Future<void> _enviarMensaje() async {
    final texto = _textController.text.trim();
    if (texto.isEmpty) return;

    _textController.clear();

    setState(() {
      _mensajes.add({'rol': 'usuario', 'texto': texto});
      _estaPensando = true;
    });

    final respuesta = await widget.guardian.ask(texto);

    setState(() {
      _mensajes.add({'rol': 'guardian', 'texto': respuesta});
      _estaPensando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interrogatorio')),
      body: Column(
        children: [
          // Mensajes
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _mensajes.length,
              itemBuilder: (context, index) {
                final msg = _mensajes[index];
                final esUsuario = msg['rol'] == 'usuario';
                return Align(
                  alignment: esUsuario ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: esUsuario ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(msg['texto']!),
                  ),
                );
              },
            ),
          ),
          
          // Indicador de carga
          if (_estaPensando) 
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),

          // Caja de texto inferior
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe tu mensaje...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _enviarMensaje(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _enviarMensaje,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}