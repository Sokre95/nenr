class Function
  def self.calculate(betas, x, y)
    Math.sin(betas[0] + betas[1] * x)
      + betas[2] * Math.cos(x * (betas[3] + y)) * (1.0 / (1 + Math.exp((x - betas[4])**2)))
  end
end