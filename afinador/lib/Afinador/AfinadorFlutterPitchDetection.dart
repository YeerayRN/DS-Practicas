import 'package:afinador/Afinador/EstrategiaAfinador.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_pitch_detection/flutter_pitch_detection.dart';

class AfinadorFlutterPitchDetection implements EstrategiaAfinador{
  static const defaultSampleRate = 44100;
  static const defaultTolerance = 0.6;
  static const defaultPrecision = 0.8;
  static const defaultBufferSize = 8196;
  static const defaultA4Reference = 440.0;

  var _detector = FlutterPitchDetection();
  StreamSubscription<Map<String, dynamic>>? _pitchSubscription; //Utilizado por FlutterPitchDetection para obtener los datos del micro

  String notaActual = "";
  double frecuenciaActual = 0.0;
  double desviacionNotaActual = 0.0;
  bool afinado = false;

  bool grabando = false;

  final int sampleRate;
  final double tolerance;
  final double precision;
  final int bufferSize;
  final double a4Reference;

  AfinadorFlutterPitchDetection({
    this.sampleRate = defaultSampleRate,
    this.tolerance = defaultTolerance,
    this.precision = defaultPrecision,
    this.bufferSize = defaultBufferSize,
    this.a4Reference = defaultA4Reference,
  }){
    this._detector.setSampleRate(44100);
    this._detector.setBufferSize(8192);
    this._detector.setMinPrecision(0.8);
    this._detector.setToleranceCents(0.6);
    this._detector.setA4Reference(440.0);
  }

  @override
  void initRec() async{
    if(!this.grabando){
      this.grabando = true;
      await this._detector.startDetection();

      this._pitchSubscription = this._detector.onPitchDetected.listen((data) async{
        this.notaActual = data['noteOctave'] ?? "";
        this.frecuenciaActual = data['frequency'] ?? 0.0;
        this.desviacionNotaActual = data['pitchDeviation'] ?? 0.0;
        this.afinado = data['isOnPitch'] ?? false;
      });

      print("AfinadorFlutterPitchDetection ha empezado a grabar");
    }
  }

  @override
  void endRec() async{
    if(this.grabando){
      try{
        await this._pitchSubscription?.cancel();
        this._pitchSubscription = null;

        await this._detector.stopDetection();

        this.grabando = false;

        this.reiniciarDatos();

        print("AfinadorFlutterPitchDetection ha parado de grabar");
      }
      catch(e){
        print("No se ha podido parar de grabar el micrófono - AfinadorFlutterPitchDetection");
      }
    }
  }


  @override
  String getNota(){
    if(this.grabando){
      return this.notaActual;
    }
    else{
      print("No se puede obtener la nota. No está grabando");
      return "";
    }
  }

  @override
  double getFrecuencia(){
    if(this.grabando){
      return this.frecuenciaActual;
    }
    else{
      print("No se puede obtener la frecuencia. No está grabando");
      return 0.0;
    }
  }

  @override
  double getDesviacion(){
    if(this.grabando){
      return this.desviacionNotaActual;
    }
    else{
      print("No se puede obtener la desviación. No está grabando");
      return 0.0;
    }
  }

  @override
  bool isAfinado(){
    if(this.grabando){
      return this.afinado;
    }
    else{
      print("No se puede obtener la afinación. No está grabando");
      return false;
    }
  }

  void reiniciarDatos(){
    this.notaActual = "";
    this.frecuenciaActual = 0.0;
    this.desviacionNotaActual = 0.0;
    this.afinado = false;
  }
}