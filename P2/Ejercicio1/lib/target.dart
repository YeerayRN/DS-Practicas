import 'struct_credenciales.dart';

class Target {
  void ejecutar(Credenciales mensaje){
    print("El correo ${mensaje.correo} ha sido validado.");
    print("La contraseña ${mensaje.password} ha sido validada.");
  }
}