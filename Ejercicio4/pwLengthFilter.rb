require_relative 'filter'

class PwLengthFilter
  include Filter

  def ejecutar(credenciales)
    if credenciales.password.length >= 10
      puts "La contraseña contiene un número de caracteres adecuado."
      return true
    else
      puts "Su contraseña es muy débil, por favor, añadele 
      al menos 10 caracteres."
      return false
    end
  end
end