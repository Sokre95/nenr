module Neural
  module ActivationFunctions
    def self.sigmoid
      lambda do |x|
        return 1 / (1 + Math.exp(-x))
      end
    end

    def self.indentity
      lambda do |x|
        return x
      end
    end
  end

  module ErrorFunctions
    def self.mse
      lambda do |x_vector, y_vector|
        res = 0.0
        x_vector.each_with_index do |x, i|
          res += (x - y_vector[i])**2
        end

        return res * 0.5
      end
    end
  end
end
