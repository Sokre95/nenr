class CalculatedFuzzySet < FuzzySet

  def initialize(domain, function)
    super(domain)
    @function = function
  end

  def get_value_at(domain_element)
    @function.call(index_of_element(domain_element))
  end
end