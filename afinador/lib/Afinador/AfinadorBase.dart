import 'package:afinador/Afinador/EstrategiaAfinador.dart';

class AfinadorBase {
  EstrategiaAfinador _afinador;

  AfinadorBase(this._afinador);

  void initRec(){
    this._afinador.initRec();
  }

  void endRec(){
    this._afinador.endRec();
  }

  String getNota(){
    return this._afinador.getNota();
  }

  double getFrecuencia(){
    return this._afinador.getFrecuencia();
  }

  double getDesviacion(){
    return this._afinador.getDesviacion();
  }

  bool isAfinado(){
    return this._afinador.isAfinado();
  }
}