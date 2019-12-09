require_relative 'selection'

class KTournamentSelection < Selection

  attr_reader :k

  def initialize(k:)
    @k = k
  end

  def select_individuals(population)
    selected = []

    @k.times do
      individual = population[rand(population.count)]
      selected << individual
    end

    selected.sort_by { |individual| individual.fitness }
  end
end