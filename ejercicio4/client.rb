class cliente
  def enviar(mensaje, filter_manager)
    filter_manager.mandar_mensaje(mensaje)
  end
end