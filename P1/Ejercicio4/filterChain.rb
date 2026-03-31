class FilterChain
  def initialize(target)
    @filters = []
    @target = target
  end

  def set_target(target)
    @target = target
  end

  def add_filter(filter)
    @filters << filter
  end

  def ejecutar(mensaje)
    cumplimiento = true
    @filters.each do |filter|
      result = filter.ejecutar(mensaje)

      if result == false
        puts "Filtro #{filter.class} ha bloqueado la ejecución. Autenticación Fallida."
        return
      end
    end
    @target.ejecutar(mensaje)
  end
end