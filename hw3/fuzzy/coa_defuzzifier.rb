module Fuzzy
  class COADefuzzifier
    def defuzzify(set)
      result = 0.0
      sum = 0.0

      set.get_domain.each do |domain_element|
        value_at_element = set.get_value_at(domain_element)

        result += domain_element.get_component_value(0) * value_at_element
        sum += value_at_element
      end

      return 0 if (sum == 0.0 && result == 0.0)
      return (result / sum).round
    end
  end
end