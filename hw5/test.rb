require_relative "./neural/net.rb"
require_relative "./neural/functions.rb"
require_relative "./neural/train_data.rb"
require_relative "app_data.rb"

require 'pry'

nn = Neural::Net.construct(
  [1, 6, 1],
  Neural::ActivationFunctions.sigmoid,
  Neural::ErrorFunctions.mse
)

train_data = Neural::TrainData.read_from_file('train2.in')

nn.train(train_data, 0.005, AppData.max_iterations, 1)

puts "gotov trening"
binding.pry
puts "kraj"

