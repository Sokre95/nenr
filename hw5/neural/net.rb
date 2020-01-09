require_relative 'layer.rb'
require_relative 'functions.rb'


module Neural
  class Net

    def self.construct(arhitecture, activation_function, error_function)
      layers = [] 
      
      # create input layer with 2 x M neurons and 1 input for each neuron
      layers << Layer.construct(arhitecture[0], 1, Neural::ActivationFunctions.indentity)
      number_of_inputs_for_next_layer = arhitecture[0]
      # create rest of the layers
      arhitecture[1..-1].each do |number_of_neurons|
        layers << Layer.construct(number_of_neurons, number_of_inputs_for_next_layer, activation_function)
        number_of_inputs_for_next_layer = number_of_neurons
      end
      self.new(layers, error_function)
    end

    def train(train_data, learning_rate, max_iterations, batch_size)
      iteration = 0
      
      while iteration < max_iterations

        batch = train_data.next_batch(batch_size)
       
        batch.each do |data| 
          forward(data[:inputs])
          back_propagate(data[:expected_outputs])
        end

        update_weights(learning_rate)

        if iteration % 1000 == 0
          puts "iteration ##{iteration} - current_error: #{calculate_error(train_data)}"
        end

        iteration += 1
        binding.pry if iteration % 50_000 == 0
      end
    end

    def predict(input)
      out = forward(input)
      max = out.max
      out.find_index(max)
    end
    
    private

    def calculate_error(train_data)
      error = 0.0

      train_data.data.each do |sample|
        error += @error_function.call(sample[:expected_outputs], forward(sample[:inputs]))
      end

      return error / train_data.data.size
    end

    def initialize(layers, error_function)
      @layers = layers
      @error_function = error_function
    end

    def forward(input)
      output = @layers[0].forward(input, true)
      
      next_layer_input = output

      @layers[1..-1].each do |layer|
        output = layer.forward(next_layer_input, false)
        next_layer_input = output
      end
      output
    end

    def back_propagate(expected_output)
      last_layer_output = Array.new(expected_output.size) { 0.0 }
      last_layer = @layers[-1].neurons.each_with_index do |neuron, i|
        last_layer_output[i] = neuron.out
      end
      error = last_layer_output.each_with_index.map { |out, i|  (expected_output[i] - out)*(1-out)*out }

      @layers[1..-1].reverse.each do |layer|
        error = layer.backward(error)
      end
    end

    def update_weights(learning_rate)
      @layers.each do |layer|
        layer.update_weights(learning_rate)
      end
    end
  end
end