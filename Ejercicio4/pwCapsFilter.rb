require_relative 'filter'

class PwCapsFilter
  include Filter

  def ejecutar(credenciales)
    tiene_mayus = credenciales.password.match?(/[A-Z]/)
    tiene_minus = credenciales.password.match?(/[a-z]/)

    if tiene_mayus and tiene_minus
      puts "Comprobación de minúsculas y mayúsculas cumplida con éxito"
      return true
    else
      puts "Contraseña no válida: debe contener al menos una letra mínuscula
      y otra mayúscula."
    end
  end
end