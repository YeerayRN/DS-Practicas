class Cliente
  def initialize(filter_manager)
    @manager = filter_manager
  end

  def enviar(mensaje)
    @manager.mandar_mensaje(mensaje)
  end
end