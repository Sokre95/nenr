class FuzzySet
  def initialize(domain)
    @domain = domain
  end

  def get_domain
    @domain
  end

  def get_value_at(domain_element)
    return NotImplementedError
  end

  private

    def index_of_element(domain_element)
      self.get_domain.index_of_element(domain_element)
    end
end