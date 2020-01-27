class CrossoverRandomProvider

  def cross(first, second)
    rand_to_method = [:simple_cross, :one_point_cross, :uniform_cross]
    self.send(rand_to_method[rand(3)], first, second)
  end

  private

  def simple_cross(first, second)
    child_values = Array.new(first.size) 

    first.values.each_with_index do |value, i|
      if first[i] > second[i]
        lower_bound = second[i]
        upper_bound = first[i]
      else
        lower_bound = first[i]
        upper_bound = second[i]
      end

      child_values[i] = rand() * (upper_bound - lower_bound) + lower_bound
    end

    Individual.create(child_values)
  end

  def one_point_cross(first, second)
    breakpoint = rand(first.size)

    Individual.create(first[0..breakpoint] + second[(breakpoint+1)..-1])
  end

  def uniform_cross(first, second)
    child_values = Array.new(first.size)

    first.values.each_with_index do |value, i|
      if rand > 0.5
        child_values[i] = first[i]
      else
        child_values[i] = second[i]
      end
    end

    Individual.create(child_values)
  end
end