require './domain'
require './simple_domain'
require './composite_domain'
require './fuzzy_set'
require './mutable_fuzzy_set'
require './calculated_fuzzy_set'
require './standard_fuzzy_sets'
require './debug'
require './relations'

u = Domain.int_range(1, 5) # {1,2,3,4}

r = MutableFuzzySet.new(Domain.combine(u, u))
  .set(DomainElement.of([1,1]), 1.0)
  .set(DomainElement.of([2,2]), 1.0)
  .set(DomainElement.of([3,3]), 1.0)
  .set(DomainElement.of([4,4]), 1.0)
  .set(DomainElement.of([1,2]), 0.3)
  .set(DomainElement.of([2,1]), 0.3)
  .set(DomainElement.of([2,3]), 0.5)
  .set(DomainElement.of([3,2]), 0.5)
  .set(DomainElement.of([3,4]), 0.2)
  .set(DomainElement.of([4,3]), 0.2)

puts "Početna relacija #{ Relations.is_fuzzy_equivalence?(r) ? 'JE' : 'NIJE'} relacije ekvivalencije"
puts "_"*43

r2 = r

3.times do |i|
  r2 = Relations.composition_of_binary_relations(r2, r)
  puts "Broj odrađenih kompozicija: #{i + 1}. Relacije je:"

  r2.get_domain.each do |de|
    puts "mu(#{de})= #{r2.get_value_at(de)}"
  end

  puts "Ova relacija #{ Relations.is_fuzzy_equivalence?(r2) ? 'JE' : 'NIJE'} relacije ekvivalencije"
  puts "_"*43
end