require_relative 'individual'
require 'pry'

class EliminationGeneticAlgorithm

  attr_reader :best

  def initialize(population_size: 50, individual_size:, net:, dataset:, selection_provider:, target_fitness: 1e-7, max_iter: 1_000_000, crossover_provider: , mutation_provider:, use_heuristic: false, stop_periodically: false)
    @population_size = population_size
    @selection_provider = selection_provider
    @crossover_provider = crossover_provider
    @mutation_provider = mutation_provider
    @net = net
    @number_of_params = @net.get_number_of_params
    @dataset = dataset
    @target_fitness = target_fitness
    @max_iter = max_iter
    @use_heuristic = use_heuristic
    @population = []
    @best = nil
    @iteration = 1
    @stop_periodically = stop_periodically
    init_population
  end

  
  def evaluate
    
    while continue_evaluating?
      print_progress()

      individuals = @selection_provider.select_individuals(@population)

      worst_parent = individuals[@selection_provider.k - 1]
      @population.delete(worst_parent)
      
      best_parent_1, best_parent_2 = individuals[0..1]
      
      child = @crossover_provider.cross(best_parent_1, best_parent_2)
      child = @mutation_provider.mutate(child)

      child.fitness = @net.calculate_error(@dataset, child.values) 

      @population << child

      @best = child if child.fitness < @best.fitness

      @iteration += 1
    end
  end

  private

    def print_progress
      puts "Iteracija #{@iteration}; fitness: #{best.fitness}" if @iteration % 100 == 0
      binding.pry if @iteration % 100_000 == 0 && @stop_periodically
    end

    def continue_evaluating?
      if @best.fitness <= @target_fitness
        puts "\tPronađeno zadovoljavajuće rješenje u #{@iteration} iteracija !"
        return false
      end

      if @iteration > @max_iter
        puts 'Dostignut max broj iteracija'
        return false
      end

      return true
    end
  
    def init_population
      params = [
        [0.125, 0.25, 0.1, 0.25], # A # 1. neuron skrivenog sloja w1 w2 s1 s2 
        [0.125, 0.75, 0.1, 0.25], # B
        [0.375, 0.25, 0.1, 0.25], # B
        [0.375, 0.75, 0.1, 0.25], # C
        [0.625, 0.25, 0.1, 0.25], # C
        [0.625, 0.75, 0.1, 0.25], # A
        [0.875, 0.25, 0.1, 0.25], # A
        [0.875, 0.75, 0.1, 0.25], # B # zadnji neuron skrivenog sloja

        [1.0, -1.0, -1.0, -1.0, -1.0, 1.0, 1.0, -1.0 ], # A
        [-1.0, 1.0, 1.0, -1.0, -1.0, -1.0, -1.0, 1.0 ], # B
        [-1.0, -1.0, -1.0, 1.0, 1.0, -1.0, -1.0, -1.0 ] # C
      ].flatten

      if @net.layers[0].number_of_inputs == 2 && @net.layers[1].number_of_inputs == 8
        new_individual = @use_heuristic ? Individual.create(params) : Individual.create_random(@number_of_params)
      else
        new_individual = Individual.create_random(@number_of_params)
      end

      new_individual.fitness = @net.calculate_error(@dataset, new_individual) 
      @best = new_individual

      @population << @best

      (@population_size - 1).times do

        new_individual = Individual.create_random(@number_of_params)
        new_individual.fitness = @net.calculate_error(@dataset, new_individual) 

        @population << new_individual
        @best = new_individual if new_individual.fitness < @best.fitness
      end
    end
end