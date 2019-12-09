require_relative 'individual'
require_relative 'genetic_algorithm'

class GenerationGeneticAlgorithm < GeneticAlgorithm

  def initialize(args)
    super(args.slice(:population_size, :selection, :crossover, :mutation, :evaluator, :target_fitness, :max_iter))
    @elitism = args[:elitism]
  end
  
  def evaluate
    
    while continue_evaluating?
      print_progress()

      new_population = []
      new_population << @best if @elitism

      while new_population.count != @population_size do
        first, second = @selection.select_individuals(@population)
        child = @crossover.cross(first, second)
        @mutation.mutate(child)

        child.fitness = @evaluator.calculate_fitness(child)
        new_population << child
        @best = child if child.fitness < @best.fitness  
      end

      @population = new_population
      @iteration += 1
    end
  end
end