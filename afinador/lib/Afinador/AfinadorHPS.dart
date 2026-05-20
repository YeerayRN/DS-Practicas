import 'package:afinador/Afinador/EstrategiaAfinador.dart';
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
//Librerías necesarias para la detección de audio nativo
import 'package:record/record.dart';
import 'package:fftea/fftea.dart';

class AfinadorHPS implements EstrategiaAfinador{
  final AudioRecorder _audioRecorder = AudioRecorder();
  StreamSubscription<Uint8List>? _audioStreamSubscription;

  static const int sampleRate = 44100;
  static const int bufferSize = 8192; // Debe ser potencia de 2 para la FFT
  final double a4Reference = 440.0;

  final List<String> notas = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];

  String _notaActual = "";
  double _frecuenciaActual = 0.0;
  double _desviacion = 0.0;
  bool _afinado = false;
  bool _grabando = false;
  final List<double> _audioBuffer = []; //ventana

  AfinadorHPS();

  @override
  void initRec() async{
    if(_grabando) return;

    if(await _audioRecorder.hasPermission()) {
      _grabando = true;

      final stream = await _audioRecorder.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: sampleRate,
          numChannels:1,
        ),
      );

      _audioStreamSubscription = stream.listen((data) {
        procesarAudio(data);
      });
      print("AfinadorHPS (Multiplataforma) ha empezado a escuchar");
    }
  }

  void procesarAudio(Uint8List data) {
    final bytes = Uint8List.fromList(data);
    Int16List pcmData = bytes.buffer.asInt16List();

    // 1. Añadir los nuevos datos al final del buffer dinámico
    for (int i = 0; i < pcmData.length; i++) {
      _audioBuffer.add(pcmData[i] / 32768.0);
    }

    // 2. Comprobar si tenemos suficientes datos acumulados
    // Usamos un while por si llegan bloques muy grandes de golpe
    while (_audioBuffer.length >= bufferSize) {

      // Extraemos exactamente el número de muestras que requiere la FFT
      List<double> signal = _audioBuffer.sublist(0, bufferSize);

      // Limpiamos los datos que acabamos de extraer para que el buffer no crezca infinitamente
      _audioBuffer.removeRange(0, bufferSize);

      // 3. Ventana de Hanning
      for (int i = 0; i < bufferSize; i++) {
        signal[i] *= 0.5 * (1 - cos(2 * pi * i / (bufferSize - 1)));
      }

      // 4. Ejecutamos FFT
      final fft = FFT(bufferSize);
      final freqDomain = fft.realFft(signal);

      List<double> magnitudes = freqDomain.magnitudes();

      // 5. Algoritmo HPS
      int maxHpsOrder = 4;
      int hpsLength = (magnitudes.length / maxHpsOrder).floor();
      List<double> hps = List.from(magnitudes.sublist(0, hpsLength));

      for (int j = 2; j <= maxHpsOrder; j++) {
        for (int i = 0; i < hpsLength; i++) {
          hps[i] *= magnitudes[i * j];
        }
      }

      // 6. Encontrar el pico (filtrando bajas frecuencias)
      double maxMagnitud = 0;
      int maxIndex = -1;
      int minIndex = (50.0 * bufferSize / sampleRate).ceil();

      for (int i = minIndex; i < hpsLength; i++) {
        if (hps[i] > maxMagnitud) {
          maxMagnitud = hps[i];
          maxIndex = i;
        }
      }

      // 7. Si el pico supera el umbral, calculamos la nota
      if (maxMagnitud > 0.01 && maxIndex > 0) {
        double freq = maxIndex * sampleRate / bufferSize;
        _calcularNota(freq);
        print("Frecuencia detectada: $freq Hz");
      }
    }
  }

  void _calcularNota(freq){
    if (freq == 0) return;

    double noteNum = 12 * (log(freq / a4Reference) / ln2) + 69;
    int closestNoteNum = noteNum.round();

    //Calcular desviación
    _desviacion = (noteNum -  closestNoteNum) * 100;
    _afinado = _desviacion.abs() < 5.0; //Tolerancia de 5

    //Mapear al nombre
    int octave = (closestNoteNum / 12).floor() - 1;
    int noteIndex = closestNoteNum % 12;
    _notaActual = "${notas[noteIndex]}$octave";
    _frecuenciaActual = freq;
  }

  @override
  void endRec() async{
    if(_grabando) {
      await _audioStreamSubscription?.cancel();
      _audioStreamSubscription = null;
      await _audioRecorder.stop();
      _grabando = false;
      _reiniciarDatos();
      print("AfinadorHPS ha parado");
    }
  }

  void _reiniciarDatos() {
    _notaActual = "";
    _frecuenciaActual = 0.0;
    _desviacion = 0.0;
    _afinado = false;
  }

  @override
  String getNota(){
    String nota = "";

    if(_grabando) nota = _notaActual;

    return nota;
  }

  @override
  double getFrecuencia(){
    double frecuencia = 0.0;

    if(_grabando) frecuencia = _frecuenciaActual;

    return frecuencia;
  }

  @override
  double getDesviacion(){
    double desviacion = 0.0;

    if(_grabando) desviacion = _desviacion;

    return desviacion;
  }

  @override
  bool isAfinado(){
    return _afinado;
  }
}