class MutableFuzzySet < FuzzySet

  def initialize(domain)
    super(domain)
    @memberships = Array.new(domain.get_cardinality, 0.0)
  end

  def get_value_at(domain_element)
    @memberships[index_of_element(domain_element)]
  end

  def set(domain_element, value)
    @memberships[index_of_element(domain_element)] = value
    self
  end
end