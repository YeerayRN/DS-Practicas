require_relative 'filter'

class PwCharactersFilter
  include Filter

  def ejecutar(credenciales)
    if credenciales.password.count("! # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ { | } ~`") > 0
      puts "Comprobación de caracteres especiales cumplida"
      return true
    else
      puts "Comprobación de caracteres especiales incorrecta. Por favor, añada algunos a su
      contraseña"
      return false
    end
  end
end