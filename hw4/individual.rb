require_relative './base_individual'

class Individual < BaseIndividual

  # Min and max value for each beta/value
  MIN = -1.0
  MAX = 1.0

  def self.create_random
    betas = 5.times.map{ rand(MIN..MAX) }
    self.new(betas)
  end

  def self.create(betas, fitness = 0.0)
    raise IndividualValuesNotCompatibleError 'Array size not compatible' if betas.count != 5
    #raise IndividualValuesNotCompatibleError 'Values not compatible' if betas.map{ |val| val > 4.0 || val < - 4.0 }.
    self.new(betas)
  end

  def to_s
    self.values.each_with_index.map{ |value, index| "B#{index}:#{value.round(4).to_s}" }.join(' ') + " -> fitness: #{self.fitness}"
    puts "betas: #{self.values}"
  end
end