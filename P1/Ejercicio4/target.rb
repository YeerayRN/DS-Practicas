class Target
  def ejecutar(message)
    puts "El correo '#{message.correo}' ha sido validado."
    puts "La contraseña '#{message.password}' ha sido validada."
  end
end