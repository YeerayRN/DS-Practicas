require relative 'filter'

class emailfilter
  include filter

  def ejecutar(credenciales)
    puts "Filtrando correo electrónico..."
    if credenciales.correo.include?("@") and !credenciales.correo.split("@")[0].empty?
      puts "Correo electrónico válido."
    else
      puts "Correo electrónico no válido. Introduzca texto antes del @."
    end
  end
end