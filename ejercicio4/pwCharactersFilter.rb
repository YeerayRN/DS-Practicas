require_relative 'filter'

class pwCharactersFilter
  include filter

  def execute(credenciales)
    if credenciales.password.count("! # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ { | } ~`")
    end
  end
end