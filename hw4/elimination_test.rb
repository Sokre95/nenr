require_relative 'individual'
require_relative 'dataset_parser'
require_relative 'evaluator'
require_relative 'k_tournament_selection'
require_relative 'elimination_genetic_algorithm'
require_relative 'mutations'

require_relative 'crossovers'

require 'pry'


evaluator = Evaluator.instance
evaluator.set_measurements(DataSetParser.parse('./data/dataset1.txt'))

elimination_ga = EliminationGeneticAlgorithm.new(
  population_size: 50,
  selection: KTournamentSelection.new(k: 3),
  crossover: Crossovers::SingleArithmeticRecombination.new,
  mutation: GausianMutation.new(0.2),
  evaluator: evaluator,
  target_fitness: 0.01,
  max_iter: 100000
)

elimination_ga.evaluate()