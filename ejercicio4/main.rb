require_relative 'client'
require_relative 'filterManager'
require_relative 'filter'
require_relative 'target'
require_relative 'struct_credenciales'
require_relative 'filterEmail'
require_relative 'filterDomain'
require_relative 'pwLengthFilter'
require_relative 'pwCharactersFilter'
require_relative 'pwCapsFilter'

correoTarget = Target.new
manager = FilterManager.new(correoTarget)

manager.add_filter(Emailfilter.new)
manager.add_filter(Filterdomain.new)
manager.add_filter(PwLengthFilter.new)
manager.add_filter(PwCharactersFilter.new)
manager.add_filter(PwCapsFilter.new)


cliente = Cliente.new(manager)

puts "===========Sistema de Autenticación de Correo==========="
print "Introduzca su correo electrónico: "
email_input = gets.chomp

print "Introduzca su contraseña: "
contraseña_input = gets.chomp

credenciales = Credenciales.new(email_input, contraseña_input)

cliente.enviar(credenciales)
