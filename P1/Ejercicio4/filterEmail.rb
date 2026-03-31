require_relative 'filter'

class Emailfilter
  include Filter

  def ejecutar(credenciales)
    puts "Filtrando correo electrónico..."
    if credenciales.correo.include?("@") and !credenciales.correo.split("@")[0].empty? and credenciales.correo.count('@') == 1
      puts "Correo electrónico válido."
      return true
    else
      puts "Correo electrónico no válido. Introduzca texto válido antes del @."
      return false
    end
  end
end