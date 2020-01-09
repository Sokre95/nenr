require_relative 'base_mutation'

class SimpleSinglePointMutation < Mutation
  def initialize(mutation_rate)
    @mutation_rate = mutation_rate
  end

  def mutate(individual)
    individual[rand(individual.size)] = rand(-4.0..4.00) if rand() < @mutation_rate
  end
end

class GausianMutation < Mutation
  def initialize(mutation_rate)
    @mutation_rate = mutation_rate
  end

  def mutate(individual)
    individual.size.times do |i|
      if rand() < @mutation_rate
        individual[i] = individual[i] * rand_normal(0, 2)
      end
    end
  end

  private
    def rand_normal(mean, stddev)
      a = rand()
      b = rand()
      a = 1.0 if a == 0.0
      b = 1.0 if b == 0.0

      c = Math.sqrt(-2.0 * Math.log(a)) * Math.cos(2.0 * Math::PI * b)
      return c * stddev + mean
    end
end