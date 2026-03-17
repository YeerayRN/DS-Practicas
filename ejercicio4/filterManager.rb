public class filterManager
  def initialize(target)
    @filter_chain = filterChain.new(target)
    @filter_chain.target = target
  end

  def add_filter(filter)
    @filter_chain.add_filter(filter)
  end

  def mandar_mensaje(mensaje)
    @filter_chain.ejecutar(mensaje)
  end
end
