require_relative './function'

class Evaluator

  attr_reader :measurements

  def self.instance
    @@instance ||= self.new
  end

  def set_measurements(measurements)
    @measurements = measurements
  end

  def calculate_fitness(individual)
    error_sum = 0.0
    @measurements.each do |measurement|
      predicted_f = Function.calculate(individual.values, measurement[:x], measurement[:y])
      error_sum += (measurement[:f] - predicted_f)**2
    end

    error_sum / @measurements.count
  end

  private

  def initialize  
  end
end