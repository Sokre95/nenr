require_relative 'individual'
require_relative 'genetic_algorithm'

class EliminationGeneticAlgorithm < GeneticAlgorithm

  def evaluate
    
    while continue_evaluating?
      print_progress()

      individuals = @selection.select_individuals(@population)

      worst_parent = individuals[@selection.k]
      @population.delete(worst_parent)

      best_parent_1, best_parent_2 = individuals[0..1]
      child = @crossover.cross(best_parent_1, best_parent_2)
      @mutation.mutate(child)

      child.fitness = @evaluator.calculate_fitness(child)
      @population << child

      @best = child if child.fitness < @best.fitness

      @iteration += 1
    end
  end
end