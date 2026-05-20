class Acorde{
  int? id = null;
  String nombre = "";
  int cuerda1 = -1; // E4 (la más fina)
  int cuerda2 = -1; // B3 (la 2ª más fina)
  int cuerda3 = -1; // G3 (la 3º más fina)
  int cuerda4 = -1; // D3 (la 3ª más gorda)
  int cuerda5 = -1; // A2 (la 2ª más gorda)
  int cuerda6 = -1; // E2 (la más gorda)

  Acorde(this.nombre, this.cuerda1, this.cuerda2, this.cuerda3, this.cuerda4, this.cuerda5, this.cuerda6);

  factory Acorde.fromJson(Map<String, dynamic> json){
    return Acorde(
      json['nombre'] as String,
      json['cuerda1'] as int,
      json['cuerda2'] as int,
      json['cuerda3'] as int,
      json['cuerda4'] as int,
      json['cuerda5'] as int,
      json['cuerda6'] as int
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id' : id,
      'nombre': nombre,
      'cuerda1': cuerda1,
      'cuerda2': cuerda2,
      'cuerda3': cuerda3,
      'cuerda4': cuerda4,
      'cuerda5': cuerda5,
      'cuerda6': cuerda6
    };
  }

  bool esValido(){
    bool valido = true;

    List<int> cuerdas = [cuerda1, cuerda2, cuerda3, cuerda4, cuerda5, cuerda6];

    for(int c in cuerdas){
      if(c < -1 || c > 22){
        valido = false;
      }
    }

    return valido;
  }
}