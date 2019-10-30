require './domain'
require './simple_domain'
require './fuzzy_set'
require './mutable_fuzzy_set'
require './calculated_fuzzy_set'
require './standard_fuzzy_sets'
require './debug'


d = Domain.int_range(0, 11)

set = MutableFuzzySet.new(d)
  .set(DomainElement.of([0]), 1.0)
  .set(DomainElement.of([1]), 0.8)
  .set(DomainElement.of([2]), 0.6)
  .set(DomainElement.of([3]), 0.4)
  .set(DomainElement.of([4]), 0.2)
Debug.print_set(set, "Set 1:")

puts
d2 = Domain.int_range(-5, 6)

set2 = CalculatedFuzzySet.new(d2, StandardFuzzySets.lambda_function(
    d2.index_of_element(DomainElement.of([-4])),
    d2.index_of_element(DomainElement.of([0])),
    d2.index_of_element(DomainElement.of([4]))
  )
)
Debug.print_set(set2, "Set 2:")
