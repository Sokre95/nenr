require_relative 'fuzzy_set'

class CalculatedFuzzySet < FuzzySet

  def initialize(domain, function)
    super(domain)
    @function = function
  end

  def get_value_at(domain_element)
    @function.call(domain_element.get_component_value(0))
  end
end