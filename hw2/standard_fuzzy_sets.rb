module StandardFuzzySets

  def self.gamma_function(a,b)
    lambda do |x|
      return 0.0 if x < a
      return 1.0 if x >= b
      return (x-a).to_f/(b-a)
    end
  end

  def self.L_function(a,b)
    lambda do |x|
      return 1.0 if x < a
      return 0.0 if x >= b
      return (b-x).to_f/(b-a)
    end
  end

  def self.lambda_function(a,b,c)
    lambda do |x|
      return 0.0 if x < a
      return 0.0 if x >= c
      return (x-a).to_f/(b-a) if x >= a and x < b
      return (c-x).to_f/(c-b) if x >= b and x < c
    end
  end
end