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
  static const int bufferSize = 8196; // Debe ser potencia de 2 para la FFT
  final double a4Reference = 440.0;

  final List<String> notas = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];

  String _notaActual = "";
  double _frecuenciaActual = 0.0;
  double _desviacion = 0.0;
  bool _afinado = false;
  bool _grabando = false;

  AfinadorHPS();

  @override
  void initRec(){
    if(grabando) return;

    if(await _audioRecorder.hasPermission()) {
      _grabando = true;

      final stream = await _audioRecorder.startStream(
        const recordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: sampleRate,
          numChannels:1,
        ),
      );

      _audioStreamSubscription = stream.listen((data) {
        _procesarAudio(data);
    });
    print("AfinadorHPS (Multiplataforma) ha empezado a escuchar");
    }
  }

  void procesarAudio(Uint8List data) {
    Int16List pcmData = Int16List.view(data.buffer);
    if(pcmData.length < bufferSize) return;

      List<double> signal = List<double>.generate(
      bufferSize, (i) => pcmData[i] / 32768.0
    );

    //Para evitar fugas espectrales
    for (int i = 0; i < bufferSize; i++) {
      signal[i] *= 0.5 * (1 - cos(2 * pi * i / (bufferSize - 1)));
    }

    //Ejecutamos FFT
    final fft = FFT(bufferSize);
    final freqDomain = fft.realFft(signal);

    List<double> magnitudes = freqDomain.magnitudes();

    //Algoritmo HPS
    int maxHpsOrder = 4; // Factor de compresión (armónicos a buscar)
    int hpsLength = (magnitudes.length / maxHpsOrder).floor();
    List<double> hps = List.from(magnitudes.sublist(0, hpsLength));

    for (int j = 2; j <= maxHpsOrder; j++) {
      for (int i = 0; i < hpsLength; i++) {
        hps[i] *= magnitudes[i * j];
      }
    }

    //Encontrar el mayor indice
    double maxMagnitud = 0;
    int maxIndex = -1;

    int minIndex = (50.0 * bufferSize / sampleRate).ceil();

    for (int i = minIndex; i < hpsLength; i++) {
      if (hps[i] > maxMagnitud) {
        maxMagnitud = hps[i];
        maxIndex = i;
      }
    }

    // Si el pico es lo suficientemente fuerte, es una nota
    if (maxMagnitud > 0.01 && maxIndex > 0) {
      // Convertir el índice del array a frecuencia en Hz
      double freq = maxIndex * sampleRate / bufferSize;
      _calcularNota(freq);
    }
  }

  @override
  void endRec(){
    if(_grabando) {
      await _audioStreamSubscription?.cancel();
      _audioStreamSubscription = null;
      await _audioRecorder.stop();
      _grabando = false;
      _reiniciarDatos();
      print("Afinador ha parado");
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

    if(_grabando) frecuencia = _frecuencia;

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