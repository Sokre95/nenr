require './domain_element'

class SimpleDomain
  include Domain
  include Enumerable

  attr_reader :first, :last, :domain_elements

  def initialize(first, last)
    @first, @last = first, last
    @domain_elements = (first..(last-1)).to_a.map{ |i| DomainElement.new([i])}
  end

  def get_cardinality
    last - first
  end

  def get_component(index)
    self
  end

  def get_number_of_components
    1
  end

  def index_of_element(domain_element)
    @domain_elements.index(domain_element)
  end

  def element_for_index(index)
    @domain_elements[index]
  end

  def each(&block)
    @domain_elements.each do |element|
      block.call(element)
    end
  end

  def to_a
    (first..(last-1)).to_a
  end
end