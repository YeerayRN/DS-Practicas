import 'package:afinador/Afinador/EstrategiaAfinador.dart';

class AfinadorHPS implements EstrategiaAfinador{
  AfinadorHPS();

  @override
  void initRec(){

  }

  @override
  void endRec(){

  }

  @override
  String getNota(){
    return "";
  }

  @override
  double getFrecuencia(){
    return 0.0;
  }

  @override
  double getDesviacion(){
    return 0.0;
  }

  @override
  bool isAfinado(){
    return false;
  }
}