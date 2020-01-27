require_relative 'layer.rb'

module Neural
  class Net

    attr_accessor :layers

    def self.construct(arhitecture, params: [])
      layers = [] 
      # create input layer with 2 x M neurons and 1 input for each neuron
      layers << Layer.construct(arhitecture[0], 1, Neural::IdentityNeuron)
      number_of_inputs_for_next_layer = arhitecture[0]
      # create second layer with TYPE 1 neurons
      layers << Layer.construct(arhitecture[1], number_of_inputs_for_next_layer, Neural::Type1Neuron)
      number_of_inputs_for_next_layer = arhitecture[1]
      
      arhitecture[2..-1].each do |number_of_neurons|
        layers << Layer.construct(number_of_neurons, number_of_inputs_for_next_layer, Neural::SigmoidalNeuron)
        number_of_inputs_for_next_layer = number_of_neurons
      end

      self.new(layers)
    end
   
    def set_params(params)
      last_index = 0

      layers[1..-1].each do |layer|
        current_layer_params = params[last_index..(last_index + layer.num_of_params - 1)]
        layer.set_params(current_layer_params)
        last_index += layer.num_of_params
      end
    end

    def calculate_error(dataset, params)
      self.set_params(params)

      error_sum = 0.0
      n = dataset.data.count.to_f

      dataset.data.each do |sample|
        outputs = self.forward([sample[:x], sample[:y]])
        outputs.each_with_index do |out, i|
          error_sum += (sample[:classification][i] - out )**2
        end
      end

      error_sum / n
    end

    def initialize(layers)
      @layers = layers
    end

    def forward(input)
      output = @layers[0].forward(input, first_layer: true)
      
      next_layer_input = output

      @layers[1..-1].each do |layer|
        output = layer.forward(next_layer_input, first_layer: false)
        next_layer_input = output
      end
      output
    end

    def get_number_of_neurons
      self.layers.sum{ |l| l.neurons.count }
    end

    def get_number_of_params
      self.layers.sum{ |l| l.num_of_params }
    end
  end
end