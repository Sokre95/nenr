module Domain

  def self.int_range(first, last)
    SimpleDomain.new(first,last)
  end

  def self.combine(domain1, domain2)
    CompositeDomain.new([domain1, domain2])
  end

  def index_of_element(domain_element)
    raise NotImplementedError
  end

  def element_for_index(index)
    raise NotImplementedError
  end

  def get_component(index)
    raise NotImplementedError
  end

  def get_cardinality
    raise NotImplementedError
  end

  def get_number_of_components
    raise NotImplementedError
  end

  def each(&block)
    raise NotImplementedError
  end

  def to_a
    raise NotImplementedError
  end
end