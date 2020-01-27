require_relative 'neuron.rb'

module Neural
  class Layer

    attr_reader :neurons, :number_of_inputs

    def self.construct(number_of_neurons, number_of_inputs, neuron_type , params: [] )
      neurons = []
      number_of_neurons.times do
        neurons << neuron_type.new(number_of_inputs, params)
      end
      self.new(neurons, number_of_inputs)
    end

    def set_params(params)
      last_index = 0
      neurons.each do |neuron|
        current_neuron_params = params[last_index..(last_index + neuron.num_of_params - 1)]
        last_index += neuron.num_of_params
        neuron.set_params(current_neuron_params)
      end
    end

    def num_of_params
      neurons.sum{ |neuron| neuron.num_of_params }
    end

    def forward(input, first_layer: false)
      outputs = []

      if first_layer
        neurons.each_with_index do |neuron, i|
          outputs << neuron.forward(input[i])
        end
      else
        neurons.each do |neuron|
          outputs << neuron.forward(input)
        end
      end

      outputs
    end
    
    private

    def initialize(neurons, number_of_inputs)
      @neurons = neurons
      @number_of_inputs = number_of_inputs
    end
  end
end