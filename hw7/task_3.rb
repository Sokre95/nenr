require_relative "./neural/net.rb"
require_relative "./data/dataset.rb"
require "pry"

net = Neural::Net.construct([2,8,3])
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

net.set_params(params)
output = net.forward([0.17, 0.25])
puts "Output: #{output}"

filepath = File.join(File.dirname(__FILE__), '../data/train-data.txt')
dataset = DataSet.read_from_file(filepath)

error = net.calculate_error(dataset, params)
puts "Erros: #{error}"
binding.pry