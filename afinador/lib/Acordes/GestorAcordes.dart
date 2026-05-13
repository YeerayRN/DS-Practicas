import 'package:afinador/Acordes/Acorde.dart';

class GestorAcordes {
  List<Acorde> _acordes = [];
  String _usuario = "";
  String apiURL = "";

  GestorAcordes(this._usuario){
    apiURL = "http://localhost:3000/acordes/${_usuario}";
  }

  void addAcorde(Acorde a){
    _acordes.add(a);
  }

  void removeAcorde(Acorde a){
    _acordes.remove(a);
  }

  List<Acorde> getAcordes(){
    return _acordes;
  }
}