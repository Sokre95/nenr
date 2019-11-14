require_relative '../hw1/domain'
require_relative '../hw1/operations'

require_relative './utils/input'
require_relative './utils/log'

require_relative './fuzzy/controller_generator'
require_relative './fuzzy/coa_defuzzifier'
  
Fuzzy::ControllerGenerator.define(
  distances_domain: Domain.int_range(0, 1301),
  acceleration_domain: Domain.int_range(-8, 20),
  rudder_domain: Domain.int_range(-90 , 91),
  s_norm: Operations.zadeh_or,
  t_norm: Operations.zadeh_and,
  implication_operator: Operations.zadeh_and,
  defuzzifier: Fuzzy::COADefuzzifier.new
)

acceleration_controller = Fuzzy::ControllerGenerator.create_acceleration_controller
rudder_controller = Fuzzy::ControllerGenerator.create_rudder_controller

while true do
  Input.read

  break if Input.values[:L] == 'K'

  acceleration = acceleration_controller.evaluate(Input.values)
  rudder = rudder_controller.evaluate(Input.values)

  # FuzzyLogger.instance.info("Input: #{Input.values}, Acceleration: #{acceleration}, Rudder: #{rudder}")

  $stdout.puts("#{acceleration} #{rudder}")
  $stdout.flush
end

FuzzyLogger.instance.info("Kraj")