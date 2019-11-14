require_relative 'mutable_fuzzy_set'

module Operations

  def self.unary_operation(set, operation)
    new_set = MutableFuzzySet.new(set.get_domain)

    set.get_domain.each do |domain_element|
      new_set.set(domain_element, operation.call(set.get_value_at(domain_element)))
    end

    new_set
  end

  class DomainsNotCompatibleError < StandardError; end

  def self.binary_operation(set, set2, operation)

    raise DomainsNotCompatibleError, "Skupovi nemaju jednake domene" unless set.get_domain == set2.get_domain

    new_set = MutableFuzzySet.new(set.get_domain)

    set.get_domain.each do |domain_element|
      value1 = set.get_value_at(domain_element)
      value2 = set2.get_value_at(domain_element)
      new_set.set(domain_element, operation.call(value1, value2))
    end

    new_set
  end

  def self.product
    lambda do |a,b|
      a * b
    end
  end

  def self.zadeh_not
    lambda do |x|
      1 - x
    end
  end

  def self.zadeh_or
    lambda do |a,b|
      [a,b].max
    end
  end

  def self.zadeh_and
    lambda do |a,b|
      [a,b].min
    end
  end

  def self.hamacher_t_norm(v)
    lambda do |a,b|
      (a*b)/(v + (1-v)*(a+b-a*b))
    end
  end

  def self.hamacher_s_norm(v)
    lambda do |a,b|
      (a+b-(2-v)*(a*b))/(1-(1-v)*(a*b))
    end
  end
end