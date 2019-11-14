require_relative '../hw1/domain'
require_relative '../hw1/operations'
require_relative '../hw1/debug'

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

a_system = Fuzzy::ControllerGenerator.create_acceleration_controller

while true do
  puts 'Upišite redni broj pravila (1,2,3...)'
  rule_number = ARGF.gets.strip.to_i
  puts 'Unesite vrijednosti (L, D, LK, DK, V, S) odvojene razmakom'
  Input.read

  rule = a_system.rules[rule_number - 1]

  res_set = rule.evaluate(Input.values)
  Debug.print_set(res_set, "Skup dobiven evaluacijom pravila #{rule_number}")

  res = Fuzzy::COADefuzzifier.new().defuzzify(res_set)
  puts "Dekodirana vrijednost: #{res}"

end

puts 'Kraj'