class MutationProvider

  attr_reader :prob1, :prob2, :prob3, :dev1, :dev2, :dev3, :t1, :t2, :t3

  def initialize(prob1:, prob2:, prob3:, dev1:, dev2:, dev3:, t1: 1, t2: 1, t3: 1)
    @prob1 = prob1
    @prob2 = prob2
    @prob3 = prob3
    @dev1 = dev1
    @dev2 = dev2
    @dev3 = dev3
    @t1 = t1
    @t2 = t2
    @t3 = t3
  end

  def mutate(individual)
    selected = select_mutation(t1,t2,t3)
    if selected == 0
      gaussian_add(individual, prob1, dev1)
    elsif selected == 1
      gaussian_add(individual, prob2, dev2)
    else
      gaussian_replace(individual, prob3, dev3)
    end
  end

  def gaussian_add(individual, prob, dev)
    individual.values.each_index do |i|
      if rand < prob
        individual[i] += rand_normal(0, dev)
      end
    end

    individual
  end

  def gaussian_replace(individual, prob, dev)
    individual.values.each_index do |i|
      if rand < prob
        individual[i] = rand_normal(0, dev)
      end
    end

    individual
  end

  private

  def select_mutation(t1,t2,t3)
    sum = t1 + t2 + t3
    v1 = t1.to_f / sum
    v2 = t2.to_f / sum
    v3 = t3.to_f / sum

    r1 = rand
    r2 = rand
    r3 = rand

    selected = [v1 > r1, v1 > r2, v3 > r3]
    selected.each_index.select{|i| selected[i] == true }.sample
  end

  def rand_normal(mean, stddev)
      a = rand()
      b = rand()
      a = 1.0 if a == 0.0
      b = 1.0 if b == 0.0

      c = Math.sqrt(-2.0 * Math.log(a)) * Math.cos(2.0 * Math::PI * b)
      return c * stddev + mean
    end

end