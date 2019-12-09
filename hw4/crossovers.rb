require_relative 'individual'

module Crossovers
  class DiscreteRecombination
    def cross(first, second)
      child_values = Array.new(first.size)
      
      first.size.times do |i|
        child_values[i] = ( rand > 0.5 ? first[i] : second[i] )
      end

      Individual.create(child_values)
    end
  end

  class SingleArithmeticRecombination
    def cross(first, second)
      child_values = first.values.dup
      
      single_index = rand(first.size)
      child_values[single_index] = (first[single_index] + second[single_index] ) / 2

      Individual.create(child_values)
    end
  end

  class SimpleArithmeticRecombination
    def cross(first, second)
      child_values = Array.new(first.size)
      breakpoint = rand(0..(first.size - 1))

      (0..breakpoint).each do |i|
        child_values[i] = first[i]
      end

      ((breakpoint + 1)..(first.size - 1)).each do |i|
        child_values[i] = (first[i] + second[i] ) / 2
      end
      
      Individual.create(child_values)      
    end
  end

  class FullArithmeticRecombination
    def cross(first, second)
      child_values = Array.new(first.size)
      
      first.size.times do |i|
        child_values[i] = (first[i] + second[i] ) / 2
      end

      Individual.create(child_values)
    end
  end

  class ArithmeticRecombination
    def cross(first, second)
      child_values = Array.new(first.size)

      p_lambda = rand()

      first.size.times do |i|
        child_values[i] = p_lambda * first[i] + (1 - p_lambda) * second[i]
      end
      Individual.create(child_values)
    end
  end
end