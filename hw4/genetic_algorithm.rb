require_relative 'individual'
require 'pry'

class GeneticAlgorithm

  attr_reader :best

  def initialize(population_size:, selection:, crossover:, mutation:, evaluator:, target_fitness:, max_iter:)
    @population_size = population_size
    @selection = selection
    @crossover = crossover
    @mutation = mutation
    @evaluator = evaluator
    @target_fitness = target_fitness
    @max_iter = max_iter

    @population = []
    @best = nil
    @iteration = 1
    init_population
  end

  def evaluate
    raise NotImplementedError
  end

  private

    def print_progress
      puts "Iteracija #{@iteration}; fitness: #{best.fitness}" if @iteration % 100 == 0
      puts @best.values
      binding.pry if @iteration % 100000 == 0
    end

    def continue_evaluating?
      if @best.fitness <= @target_fitness
        puts "\tPronađeno zadovoljavajuće rješenje u #{@iteration} iteracija !"

        puts "\t#{best.to_s}"
        return false
      end

      if @iteration > @max_iter
        puts 'Dostignut max broj iteracija'
        return false
      end

      return true
    end
  
    def init_population
      new_individual = Individual.create_random
      new_individual.fitness = @evaluator.calculate_fitness(new_individual)
      @best = new_individual

      @population_size.times do

        new_individual = Individual.create_random()
        new_individual.fitness = @evaluator.calculate_fitness(new_individual)

        @population << new_individual
        @best = new_individual if new_individual.fitness < @best.fitness
      end
    end
end