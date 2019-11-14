require_relative './domain'
require_relative './debug'

d1 = Domain.int_range(0, 5)
Debug.print_domain(d1, "Elementi domene 1")

d2 = Domain.int_range(0, 3)
Debug.print_domain(d2, "Elementi domene 2")

d3 = Domain.combine(d1, d2)
Debug.print_domain(d3, "Elementi domene 3")

puts d3.element_for_index(0)
puts d3.element_for_index(5)
puts d3.element_for_index(14)

puts d3.index_of_element(DomainElement.of([4,1]))