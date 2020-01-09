module Neural
  class Neuron

    attr_reader :weights, :out, :current_inputs
    
    def self.create(num_of_inputs, activation_function)
      neuron = self.new(num_of_inputs, 0.0, activation_function)
      neuron
    end
    
    def forward(inputs)
      @current_inputs = inputs
      @out = 0.0
      @current_inputs.each_with_index do |input, i|
        @out += @weights[i] * input
      end
      @out += @bias
      @out = @activation_function.call(@out)
      @out
    end

    def backward(gradient)
      current_local_gradient = derivative_part * gradient
      @local_gradient_sum += current_local_gradient

      current_local_gradient
    end

    def update_weights(learning_rate)
      @weights.each_with_index do |weight, i|
        @weights[i] += learning_rate * @local_gradient_sum * @current_inputs[i]
      end

      @bias += @local_gradient_sum * learning_rate

      @out = 0.0
      @local_gradient_sum = 0.0
    end

    private

    def derivative_part
      @out * (1 - @out)  
    end

    def initialize(num_of_inputs, bias, activation_function)
      @num_of_inputs = num_of_inputs
      @weights = Array.new(num_of_inputs) { rand / 5.0 }
      @bias = 0.0
      @activation_function = activation_function
      @out = 0.0
      @local_gradient_sum = 0.0

      init_weights
    end

    def init_weights
      @weights.each do |weight| 
        weight = rand(2) - 1
      end
    end
  end
end