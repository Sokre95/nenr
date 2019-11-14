require_relative 'system'
require_relative 'rule'
require_relative 'proposition'

require_relative '../../hw1/standard_fuzzy_sets'


module Fuzzy
  module ControllerGenerator
    def self.define(distances_domain:, acceleration_domain:, rudder_domain:, s_norm:, t_norm:, implication_operator:, defuzzifier:)
      @@distances_domain = distances_domain
      @@acceleration_domain = acceleration_domain
      @@rudder_domain = rudder_domain
      @@s_norm = s_norm
      @@t_norm = t_norm
      @@implication_operator = implication_operator
      @@defuzzifier = defuzzifier
    end

    def self.create_acceleration_controller
      a_system = Fuzzy::System.new(@@s_norm, @@defuzzifier)

      # propositions
      l_close = Fuzzy::Proposition.new(@@distances_domain, StandardFuzzySets.L_function(25, 45), :L)
      lk_close = Fuzzy::Proposition.new(@@distances_domain, StandardFuzzySets.L_function(30, 55), :LK)
      d_close = Fuzzy::Proposition.new(@@distances_domain, StandardFuzzySets.L_function(25, 45), :D)
      dk_close = Fuzzy::Proposition.new(@@distances_domain, StandardFuzzySets.L_function(30, 55), :DK)
      
      l_away = Fuzzy::Proposition.new(@@distances_domain, StandardFuzzySets::gamma_function(35, 50), :L)
      lk_away = Fuzzy::Proposition.new(@@distances_domain, StandardFuzzySets::gamma_function(35, 65), :LK)
      d_away = Fuzzy::Proposition.new(@@distances_domain, StandardFuzzySets::gamma_function(35, 50), :D)
      dk_away = Fuzzy::Proposition.new(@@distances_domain, StandardFuzzySets::gamma_function(35, 65), :DK)

      decelerate = Fuzzy::Proposition.new(@@acceleration_domain, StandardFuzzySets.L_function(-4, 0), :A)
      accelerate = Fuzzy::Proposition.new(@@acceleration_domain, StandardFuzzySets.gamma_function(0, 11), :A)

      # rules
      left_close_rule = Fuzzy::Rule.new(@@t_norm, @@implication_operator)
      left_close_rule.add_antecedent(l_close).add_antecedent(lk_close).add_consequent(decelerate)
      left_away_rule = Fuzzy::Rule.new(@@t_norm, @@implication_operator)
      left_away_rule.add_antecedent(l_away).add_antecedent(lk_away).add_consequent(accelerate)

      right_close_rule = Fuzzy::Rule.new(@@t_norm, @@implication_operator)
      right_close_rule.add_antecedent(d_close).add_antecedent(dk_close).add_consequent(decelerate)
      right_away_rule = Fuzzy::Rule.new(@@t_norm, @@implication_operator)
      right_away_rule.add_antecedent(d_away).add_antecedent(dk_away).add_consequent(accelerate)

      a_system
        .add_rule(left_close_rule)
        .add_rule(left_away_rule)
        .add_rule(right_close_rule)
        .add_rule(right_away_rule)
    end

    def self.create_rudder_controller
      r_system = Fuzzy::System.new(@@s_norm, @@defuzzifier)

      # propositions
      l_close = Fuzzy::Proposition.new(@@distances_domain, StandardFuzzySets.L_function(23, 40), :L)
      lk_close = Fuzzy::Proposition.new(@@distances_domain, StandardFuzzySets.L_function(34, 75), :LK)

      d_close = Fuzzy::Proposition.new(@@distances_domain, StandardFuzzySets.L_function(23, 40), :D)
      dk_close = Fuzzy::Proposition.new(@@distances_domain, StandardFuzzySets.L_function(34, 75), :DK)

      smoothly_steer_right = Fuzzy::Proposition.new(@@rudder_domain, StandardFuzzySets.L_function(-70, -20), :K)
      smoothly_steer_left = Fuzzy::Proposition.new(@@rudder_domain, StandardFuzzySets.gamma_function(20, 70), :K)

      sharp_steer_right = Fuzzy::Proposition.new(@@rudder_domain, StandardFuzzySets.L_function(-90, -60), :K)
      sharp_steer_left = Fuzzy::Proposition.new(@@rudder_domain, StandardFuzzySets.gamma_function(60, 90), :K)


      # rules
      left_close_rule = Fuzzy::Rule.new(@@t_norm, @@implication_operator)
      left_close_rule.add_antecedent(l_close).add_antecedent(lk_close).add_consequent(smoothly_steer_right)

      right_close_rule = Fuzzy::Rule.new(@@t_norm, @@implication_operator)
      right_close_rule.add_antecedent(d_close).add_antecedent(dk_close  ).add_consequent(smoothly_steer_left)

      left_angle_close_rule = Fuzzy::Rule.new(@@t_norm, @@implication_operator)
      left_angle_close_rule.add_antecedent(lk_close).add_consequent(sharp_steer_right)

      right_angle_close_rule = Fuzzy::Rule.new(@@t_norm, @@implication_operator)
      right_angle_close_rule.add_antecedent(dk_close).add_consequent(sharp_steer_left)

      r_system
        .add_rule(left_angle_close_rule)
        .add_rule(right_angle_close_rule)
        .add_rule(left_close_rule)
        .add_rule(right_close_rule)
    end
  end
end