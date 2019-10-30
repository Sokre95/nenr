require './domain'
require './simple_domain'
require './composite_domain'
require './fuzzy_set'
require './mutable_fuzzy_set'
require './calculated_fuzzy_set'
require './standard_fuzzy_sets'
require './debug'
require './relations'

u1 = Domain.int_range(1, 5) # {1,2,3,4}
u2 = Domain.int_range(1, 4) # {1,2,3}
u3 = Domain.int_range(1, 5) # {1,2,3,4}

r1 = MutableFuzzySet.new(Domain.combine(u1,u2))
  .set(DomainElement.of([1,1]), 0.3)
  .set(DomainElement.of([1,2]), 1)
  .set(DomainElement.of([3,3]), 0.5)
  .set(DomainElement.of([4,3]), 0.5)

r2 = MutableFuzzySet.new(Domain.combine(u2,u3))
  .set(DomainElement.of([1,1]), 1)
  .set(DomainElement.of([2,1]), 0.5)
  .set(DomainElement.of([2,2]), 0.7)
  .set(DomainElement.of([3,3]), 1)
  .set(DomainElement.of([3,4]), 0.4)

#Debug.print_set(r1, "R1:")
#Debug.print_set(r2, "R2:")

r1r2 = Relations.composition_of_binary_relations(r1,r2)

r1r2.get_domain.each do |domain_element|
  puts "mu(#{domain_element}= #{r1r2.get_value_at(domain_element)}"
end
