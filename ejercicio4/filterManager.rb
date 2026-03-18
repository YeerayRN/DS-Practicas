require_relative 'filterChain'

class FilterManager
  def initialize(target)
    @filter_chain = FilterChain.new(target)
  end

  def add_filter(filter)
    @filter_chain.add_filter(filter)
  end

  def mandar_mensaje(mensaje)
    @filter_chain.ejecutar(mensaje)
  end
end
