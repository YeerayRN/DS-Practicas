require relative 'filter'

class pwLengthFilter
  include filter

  def execute(credenciales)
    if credenciales.password.length >= 10
      puts "La contraseña contiene un número de caracteres adecuado."
    else
      puts "Su contraseña es muy débil, por favor, añadele 
      al menos 10 caracteres."

end