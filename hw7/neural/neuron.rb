module Neural
  class BaseNeuron

    attr_reader :num_of_inputs
    attr_accessor :weights

    def initialize(num_of_inputs, weights)
      @num_of_inputs = num_of_inputs
      @weights = weights
    end

    def forward
      raise NotImplementedError
    end

    def num_of_params
      raise NotImplementedError
    end
  end


  class NeuronInputNotCompatible < StandardError; end
  class IdentityNeuronDoesntHaveParams < StandardError; end

  class IdentityNeuron < BaseNeuron

    def forward(input)
      raise NeuronInputNotCompatible, "Idenity neuron input is not number" if input.class != Integer && input.class != Float
      input
    end

    def num_of_params
      0
    end

    def set_params
      raise IdentityNeuronDoesntHaveParams
    end
  end


  class SigmoidalNeuron < BaseNeuron
    def forward(inputs)
      sum = 0.0
      inputs.each_with_index do |input, i|
        sum += input * weights[i]
      end

      1.0 / (1.0 + Math.exp(-sum))
    end

    def num_of_params
      num_of_inputs
    end

    def set_params(params)
      raise NeuronInputNotCompatible, "Sigmoidal neuron must have number of params equal to num of inputs" if params.count != num_of_inputs
      @weights = params.map(&:to_f)
    end
  end

  class Type1Neuron < BaseNeuron

    attr_reader :biases

    def initialize(num_of_inputs, params)
      super(num_of_inputs, params[0..(num_of_inputs-1)])
      @biases = params[num_of_inputs..(2*num_of_inputs-1)]
    end


    def forward(inputs)
      sum = 0.0

      inputs.each_with_index do |input, i|
        sum += (input - weights[i]).abs / biases[i].abs
      end
      1.0 / (1.0 + sum)
    end

    def num_of_params
      num_of_inputs * 2
    end

     def set_params(params)
      raise NeuronInputNotCompatible, "Type1Neuron neuron must have number of params double as num of inputs" if params.count != num_of_inputs * 2

      params = params.map(&:to_f)

      @weights = params[0..(num_of_inputs - 1)]
      @biases = params[weights.size..(2*num_of_inputs - 1)]
    end
  end
end