require_relative 'neuron.rb'

module Neural
  class Layer

    attr_reader :neurons, :number_of_inputs

    def self.construct(number_of_neurons, number_of_inputs, activation_function)
      neurons = []

      number_of_neurons.times do
        neurons << Neural::Neuron.create(number_of_inputs, activation_function)
      end

      self.new(neurons, number_of_inputs)
    end

    def forward(input, first_layer = false)
      outputs = []

      if first_layer
        neurons.each_with_index do |neuron, i|
          outputs << neuron.forward([input[i]])
        end
      else
        neurons.each do |neuron|
          outputs << neuron.forward(input)
        end
      end

      outputs
    end

    def backward(error)
      neurons_gradient = Array.new(@neurons.size) { 0.0 }

      number_of_neurons_back = @neurons[0].current_inputs.size

      @neurons.each_with_index do |neuron, i|
        neurons_gradient[i] = neuron.backward(error[i])
      end

      next_neurons_gradient = Array.new(number_of_neurons_back) { 0.0 }

      number_of_neurons_back.times do |i|
        current_gradient = 0.0
        neurons_gradient.each_with_index do |j|
          current_gradient += neurons_gradient[j] * @neurons[j].weights[i]
        end
        next_neurons_gradient[i] = current_gradient
      end

      next_neurons_gradient
    end

    def update_weights(learning_rate)
      @neurons.each do |neuron|
        neuron.update_weights(learning_rate)
      end
    end
    
    private

    def initialize(neurons, number_of_inputs)
      @neurons = neurons
      @number_of_inputs = number_of_inputs
    end
  end
end