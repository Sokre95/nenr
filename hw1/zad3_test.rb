require_relative './domain'
require_relative './operations'
require_relative './debug'


d = Domain.int_range(0, 11)

set = MutableFuzzySet.new(d)
  .set(DomainElement.of([0]), 1.0)
  .set(DomainElement.of([1]), 0.8)
  .set(DomainElement.of([2]), 0.6)
  .set(DomainElement.of([3]), 0.4)
  .set(DomainElement.of([4]), 0.2)
Debug.print_set(set, "Set1:")

puts

not_set = Operations.unary_operation(set, Operations.zadeh_not)
Debug.print_set(not_set, "notSet1:")

puts

set_union_not_set = Operations.binary_operation(set, not_set, Operations.zadeh_or)
Debug.print_set(set_union_not_set, "Set1 union notSet1:")

puts

hinters = Operations.binary_operation(set, not_set, Operations.hamacher_t_norm(1.0))
Debug.print_set(hinters, "Set1 intersection with notSet1 using parameterised Hamacher T norm with parameter 1.0:")