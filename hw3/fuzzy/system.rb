module Fuzzy
  class System

    attr_reader :rules, :s_norm ,:defuzzifier

    def initialize(s_norm, defuzzifier)
      @s_norm = s_norm # union operator
      @defuzzifier = defuzzifier
      @rules = []
    end

    def add_rule(rule)
      @rules << rule
      self
    end

    def evaluate(values)
      res_set = conclude(values)

      defuzzifier.defuzzify(res_set)
    end

    def conclude(values)
      rules_union = @rules[0].evaluate(values)

      @rules[1..-1].each do |rule|
        rule_evaluated = rule.evaluate(values)
        rules_union = Operations.binary_operation(rules_union, rule_evaluated, s_norm)
      end
      
      rules_union
    end
  end
end