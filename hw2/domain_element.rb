class DomainElement

  attr_reader :values
    
  def initialize(values)
    @values = values
  end

  def self.of(values)
    self.new(values)
  end

  def get_number_of_components
    @values.count
  end

  def get_component_value(i)
    @values[i]
  end

  def to_s
    return "(#{@values.join(',')})" if @values.count > 1
    return @values.first.to_s
  end

  def ==(other_element)
    @values == other_element.values
  end
end