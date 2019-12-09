class BaseIndividual

  attr_reader :values
  attr_accessor :fitness

  class IndividualValuesNotCompatibleError < StandardError; end
  def self.create(values, fitness)
    self.new(values, fitness)
  end

  def self.create_random
    raise NotImplementedError
  end

  def size
    values.size
  end

  def [](index)
    values[index]
  end

  def []=(index,value)
    values[index] = value 
  end

  def to_s
    raise NotImplementedError
  end

 private

    def initialize(values = [], fitness = 0.0)
      @values = values
      @fitness = fitness
    end
end