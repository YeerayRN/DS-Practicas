import 'package:afinador/Afinador/EstrategiaAfinador.dart';
import 'package:afinador/Afinador/Sensores.dart';
import 'package:afinador/Afinador/Observador.dart';
import 'package:afinador/Afinador/datosAfinador.dart';

class AfinadorBase implements Sensores{
  final List<Observador> _observadores = [];
  EstrategiaAfinador _afinador;

  AfinadorBase(this._afinador);

  @override
  void addObservador(Observador o) => _observadores.add(o);

  @override
  void removeObservador(Observador o) => _observadores.remove(o);

  @override
  void notificar(DatosAfinador datos) {
    for (final o in _observadores) {
      o.update(datos);
    }
  }

  void initRec(){
    this._afinador.initRec(notificar);
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