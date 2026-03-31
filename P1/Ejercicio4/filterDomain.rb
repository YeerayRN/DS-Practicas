require_relative 'filter'

class Filterdomain
  include Filter
  
  def ejecutar(credenciales)
    puts "Filtrando dominio..."
    if credenciales.correo.end_with?("@gmail.com") or credenciales.correo.end_with?("@hotmail.com")
      puts "Dominio válido."
      return true
    else
      puts "Dominio no válido. El correo debe pertenecer a los dominios
       '@gmail.com' o '@hotmail.com'."
       return false
    end
  end
end
