require_relative "./neural/net.rb"
require_relative "./data/dataset.rb"
require_relative "./genetic/mutation_provider.rb"
require_relative "./genetic/crossover_provider.rb"
require_relative "./genetic/crossover_provider.rb"
require_relative './genetic/k_tournament_selection.rb'
require_relative './genetic/elimination_genetic_algorithm'

require "pry"

export_params_files = File.join(File.dirname(__FILE__), './data/params_2643.txt')

filepath = File.join(File.dirname(__FILE__), './data/train-data.txt')
dataset = DataSet.read_from_file(filepath)
net = Neural::Net.construct([2,6,4,3])

mutation_provider = MutationProvider.new(
  prob1: 0.04,
  prob2: 0.04,
  prob3: 0.01,
  dev1: 0.15,
  dev2: 0.35,
  dev3: 0.8,
  t1: 1,
  t2: 1,
  t3: 1
)

elimination_ga = EliminationGeneticAlgorithm.new(
  population_size: 50,
  individual_size: net.get_number_of_params,
  selection_provider: KTournamentSelection.new(k: 5),
  crossover_provider: CrossoverRandomProvider.new,
  mutation_provider: mutation_provider,
  net: net,
  dataset: dataset,
  target_fitness: 1e-7,
  max_iter: 1_000_000,
  use_heuristic: false,
  stop_periodically: false
)

elimination_ga.evaluate

puts "Najbolje rješenje - fitness: #{elimination_ga.best.fitness.round(10)}\nValues:\n#{elimination_ga.best.values}"

params_file = File.open(export_params_files, "w")
params_file.write("fitness: #{elimination_ga.best.fitness}\nvalues: #{elimination_ga.best.values}")
params_file.close

binding.pry

puts "Kraj"