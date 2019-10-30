module Relations

  def self.is_U_times_U_relation?(relation)
    domain = relation.get_domain
    return false if domain.get_number_of_components != 2
    return domain.get_component(0) == domain.get_component(1)
  end

  def self.is_symetric?(relation)
    return false unless self.is_U_times_U_relation?(relation)

    relation.get_domain.each do |domain_element|
      first, second = domain_element.values
      symetrical_el = DomainElement.of([second, first])

      return false if relation.get_value_at(domain_element) != relation.get_value_at(symetrical_el)
    end

    return true
  end

  def self.is_reflexive?(relation)
    return false unless self.is_U_times_U_relation?(relation)

    relation.get_domain.get_component(0).to_a.each do |value|
      return false if relation.get_value_at(DomainElement.of([value,value])) != 1.0
    end

    return true
  end

  def self.is_max_min_transitive?(relation)
    return false unless self.is_U_times_U_relation?(relation)

    relation.get_domain.each do |domain_element|
      x, z = domain_element.values
      max = 0.0

      relation.get_domain.get_component(0).to_a.each do |y|
        xy_el = DomainElement.of([x,y])
        yz_el = DomainElement.of([y,z])

        xy_value = relation.get_value_at(xy_el)
        yz_value = relation.get_value_at(yz_el)

        current_min = [xy_value, yz_value].min
        max = current_min if current_min > max
      end
      return false if relation.get_value_at(domain_element) < max
    end

    return true
  end

  class RelationsNotCompatibleError < StandardError; end

  def self.composition_of_binary_relations(r1, r2)
    unless r1.get_domain.get_component(1) == r2.get_domain.get_component(0)
      raise RelationsNotCompatibleError, "Nije moguca kompozicija ovakvih relacija"
    end

    d_composite = Domain.combine(
      r1.get_domain.get_component(0), # X x Y
      r2.get_domain.get_component(1)  # Y x Z
    )
    r_composite = MutableFuzzySet.new(d_composite) # X x Z, { 0.0 }
    y_domain = r1.get_domain.get_component(1)


    d_composite.each do |domain_element| # each (x,z)

      minimums = []

      y_domain.to_a.each do |y_el|
        xy_el = DomainElement.of([domain_element.values[0], y_el])
        yz_el = DomainElement.of([y_el, domain_element.values[1]])

        minimums << [r1.get_value_at(xy_el) , r2.get_value_at(yz_el)].min
      end

      r_composite.set(domain_element, minimums.max)
    end

    return r_composite
  end

  def self.is_fuzzy_equivalence?(relation)
    return false unless self.is_symetric?(relation)
    return false unless self.is_reflexive?(relation)
    return false unless self.is_max_min_transitive?(relation)
    
    return true
  end
end