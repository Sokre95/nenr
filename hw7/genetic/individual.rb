require_relative './base_individual'

class Individual < BaseIndividual

  MIN = 0.05
  MAX = 0.95

  def self.create_random(size)
    params = size.times.map{ rand(MIN..MAX) }
    self.new(params)
  end

  class IndividualValuesNotCompatibleError < StandardError; end

  def self.create(params, fitness = 0.0)
    self.new(params, fitness)
  end

  def to_s
    self.values.each_with_index.map{ |value, index| "#{value.round(4).to_s}" }.join(' ') + "\n\t -> fitness: #{self.fitness}"
  end
end