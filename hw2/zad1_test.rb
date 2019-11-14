require_relative '../hw1/domain'
require_relative '../hw1/mutable_fuzzy_set'
require_relative '../hw1/debug'
require_relative 'relations'

u1 = Domain.int_range(1, 6)
#Debug.print_domain(u1, "Elementi domene u1")

u2 = Domain.combine(u1,u1)
#Debug.print_domain(u2, "Elementi domene u2")

r1 = MutableFuzzySet.new(u2)
  .set(DomainElement.of([1,1]), 1.0)
  .set(DomainElement.of([2,2]), 1.0)
  .set(DomainElement.of([3,3]), 1.0)
  .set(DomainElement.of([4,4]), 1.0)
  .set(DomainElement.of([5,5]), 1.0)
  .set(DomainElement.of([3,1]), 0.5)
  .set(DomainElement.of([1,3]), 0.5)

r2 = MutableFuzzySet.new(u2)
  .set(DomainElement.of([1,1]), 1.0)
  .set(DomainElement.of([2,2]), 1.0)
  .set(DomainElement.of([3,3]), 1.0)
  .set(DomainElement.of([4,4]), 1.0)
  .set(DomainElement.of([5,5]), 1.0)
  .set(DomainElement.of([3,1]), 0.5)
  .set(DomainElement.of([1,3]), 0.1)

r3 = MutableFuzzySet.new(u2)
  .set(DomainElement.of([1,1]), 1.0)
  .set(DomainElement.of([2,2]), 1.0)
  .set(DomainElement.of([3,3]), 0.3)
  .set(DomainElement.of([4,4]), 1.0)
  .set(DomainElement.of([5,5]), 1.0)
  .set(DomainElement.of([1,2]), 0.6)
  .set(DomainElement.of([2,1]), 0.6)
  .set(DomainElement.of([2,3]), 0.7)
  .set(DomainElement.of([3,2]), 0.7)
  .set(DomainElement.of([3,1]), 0.5)
  .set(DomainElement.of([1,3]), 0.5)

r4 = MutableFuzzySet.new(u2)
  .set(DomainElement.of([1,1]), 1.0)
  .set(DomainElement.of([2,2]), 1.0)
  .set(DomainElement.of([3,3]), 1.0)
  .set(DomainElement.of([4,4]), 1.0)
  .set(DomainElement.of([5,5]), 1.0)
  .set(DomainElement.of([1,2]), 0.4)
  .set(DomainElement.of([2,1]), 0.4)
  .set(DomainElement.of([2,3]), 0.5)
  .set(DomainElement.of([3,2]), 0.5)
  .set(DomainElement.of([1,3]), 0.4)
  .set(DomainElement.of([3,1]), 0.4)


#Debug.print_set(r1, "R 1:")

test1 = Relations.is_U_times_U_relation?(r1)
puts "r1 #{test1 ? "JE" : 'NIJE'} definirana nad UxU" 

test2 = Relations.is_symetric?(r1)
puts "r1 #{test2 ? "JE" : 'NIJE'} simetrična"

test3 = Relations.is_symetric?(r2)
puts "r2 #{test3 ? "JE" : 'NIJE'} simetrična" 

test4 = Relations.is_reflexive?(r1)
puts "r1 #{test4 ? "JE" : 'NIJE'} refleksivna"

test5 = Relations.is_reflexive?(r3)
puts "r3 #{test5 ? "JE" : 'NIJE'} refleksivna" 

test6 = Relations.is_max_min_transitive?(r3)
puts "r3 #{test6 ? "JE" : 'NIJE'} max-min tranzitivna" 

test7 = Relations.is_max_min_transitive?(r4)
puts "r4 #{test7 ? "JE" : 'NIJE'} max-min tranzitivna" 

puts "Bye"