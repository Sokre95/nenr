require_relative "./neural/net.rb"
require_relative "./data/dataset.rb"

require "pry"

#export_params_files = File.join(File.dirname(__FILE__), './data/params_283_bad.txt')
export_params_files = File.join(File.dirname(__FILE__), './data/params_2843.txt')
dataset_filepath = File.join(File.dirname(__FILE__), './data/train-data.txt')
params_file = File.open(export_params_files, "r")
best_params = JSON.parse(params_file.read.split("\n")[1].split("values: ")[1])

dataset = DataSet.read_from_file(dataset_filepath)
net = Neural::Net.construct([2,8,4,3])

net.set_params(best_params)
wrong = 0

dataset.data.each do |sample|
  out = net.forward([sample[:x], sample[:y]])
  out_class_array = out.map { |o| o <= 0.5 ? 0 : 1}

  unless DataSet::INDEX_TO_CLASS_MAPINGS[out_class_array.index(1)] == sample[:sample_class]
    puts "Wrong classification: input #{ sample.to_s }, out: #{out_class_array}, out_raw: #{ out }"
    wrong += 1
  end
end

puts "Ispravno klasificirano #{dataset.data.count - wrong}/#{dataset.data.count} uzoraka"