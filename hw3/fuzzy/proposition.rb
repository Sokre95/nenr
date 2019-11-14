require_relative '../../hw1/calculated_fuzzy_set'
require_relative '../../hw1/domain_element'

module Fuzzy
  class Proposition
    attr_reader :fuzzy_set, :variable, :domain

    def initialize(domain, function, var)
      @fuzzy_set = CalculatedFuzzySet.new(domain, function)
      @variable = var
    end

    def get_affiliation(input_values)
      input_value = input_values[@variable]
      @fuzzy_set.get_value_at(DomainElement.of([input_value]))
    end
  end
end