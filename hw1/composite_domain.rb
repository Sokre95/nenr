require_relative 'domain_element'

class CompositeDomain
  include Domain
  include Enumerable

  attr_reader :domain_elements
  
  def initialize(simple_domains)
    @domains = simple_domains
    @domain_elements = create_domain_elements(simple_domains)
  end

  def get_cardinality
    @domain_elements.count
  end

  def get_component(index)
    @domains[index]
  end

  def get_number_of_components
    @domains.count
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

  private

    def create_domain_elements(simple_domains)
      elements = cartesian_product_array(simple_domains)
      elements.map do |element|
        DomainElement.of(element)
      end
    end

    def cartesian_product_array(simple_domains)
      simple_domains[0].to_a.product(
        *simple_domains[1..-1].map(&:to_a)
      )
    end
end