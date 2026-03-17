require relative 'filter'

class filterdomain
  include filter
  
  def ejecutar(credenciales)
    puts "Filtrando dominio..."
    if credenciales.correo.end_with?("@gmail.com") or credenciales.correo.end_with?("@hotmail.com")
      puts "Dominio válido."
    else
      puts "Dominio no válido. El correo debe pertenecer a los dominios
       '@gmail.com' o '@hotmail.com'."
    end
  end
end
