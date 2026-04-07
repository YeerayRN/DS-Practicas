import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'secret_keeper.dart';
import 'basic_secret_keeper.dart';
import 'strong_prompt_decorator.dart';
import 'keyword_block_decorator.dart';
import 'length_limit_decorator.dart';

void main() {
  dotenv.load(fileName: ".env").then((_) {
  runApp(const GuardianGameApp());
  });
}

class GuardianGameApp extends StatelessWidget {
  const GuardianGameApp({super.key});

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

// ==========================================
// PANTALLA 1: SELECCIÓN DE DIFICULTAD
// ==========================================
class DifficultySelectionScreen extends StatelessWidget {
  const DifficultySelectionScreen({super.key});

  // ¡AQUÍ OCURRE LA MAGIA DEL PATRÓN DECORATOR!
  SecretKeeper _crearGuardian(String dificultad) {
    const apiKey = 'TU_API_KEY_AQUI'; // ¡Pon aquí tu clave de Gemini!
    
    // Nivel Base (Fácil)
    SecretKeeper guardian = BasicSecretKeeper("Pera",apiKey);

    if (dificultad == 'Medio') {
      // Nivel Medio: Envolvemos al básico con el rol gruñón
      guardian = StrongPromptDecorator(guardian);
    } 
    else if (dificultad == 'Difícil') {
      // Nivel Difícil: Envolvemos con todas las capas de seguridad
      guardian = StrongPromptDecorator(guardian);
      guardian = KeywordBlockDecorator(guardian);
      guardian = LengthLimitDecorator(guardian);
    }

    return guardian;
  }

  void _iniciarJuego(BuildContext context, String dificultad) {
    final guardianConfigurado = _crearGuardian(dificultad);

    // Navegamos a la pantalla de chat pasándole el guardián ya montado
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

// ==========================================
// PANTALLA 2: EL CHAT
// ==========================================
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

    // 1. Añadir mensaje del usuario a la lista
    setState(() {
      _mensajes.add({'rol': 'usuario', 'texto': texto});
      _estaPensando = true;
    });

    // 2. Comunicarse con el Guardián (usando el polimorfismo del Decorator)
    final respuesta = await widget.guardian.ask(texto);

    // 3. Añadir respuesta del Guardián a la lista
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
          // Área de los mensajes
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