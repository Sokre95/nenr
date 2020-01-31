require "pry"

class Anfis

  SIGMOIDAL_PARAMS = [:a, :b, :c, :d] # precondition params 
  OUT_PARAMS = [:p, :q, :r] # consequent params
  PARAMS = SIGMOIDAL_PARAMS + OUT_PARAMS 

  attr_reader :errors, :rules

  def initialize(num_of_rules) # m rules
    @rules = Array.new(num_of_rules) do
      {
        a: { val: rand(-1.0..1.0), der: 0.0 },
        b: { val: rand(-1.0..1.0), der: 0.0 },
        c: { val: rand(-1.0..1.0), der: 0.0 },
        d: { val: rand(-1.0..1.0), der: 0.0 },
        p: { val: rand(-1.0..1.0), der: 0.0 },
        q: { val: rand(-1.0..1.0), der: 0.0 },
        r: { val: rand(-1.0..1.0), der: 0.0 },
        sigm_A_out: 0.0,
        sigm_B_out: 0.0,
        weight: 0.0,
        out: 0.0
      }
    end
  end

  def train(type: :stohastic, samples:, max_iterations: 100_000, print_progress_flag: true, status_every_n_iterations: 100, learing_rate_precondition: 0.0001, learing_rate_consequent: 0.01, target_error: 1e-6, save_error_every_n_iterations: 100)
    return false if type != :stohastic && type != :batch

    @samples = samples
    @type = type
    @max_iterations = max_iterations
    @print_progress_flag = print_progress_flag
    @status_every_n_iterations = status_every_n_iterations
    @learing_rate_precondition = learing_rate_precondition
    @learing_rate_consequent = learing_rate_consequent
    @target_error = target_error
    @save_error_every_n_iterations = save_error_every_n_iterations

    @iteration = 0
    @learned = false

    @errors = []
    while @iteration < @max_iterations || @learned do
      stohastic_step(@samples) if @type == :stohastic
      batch_step(@samples) if @type == :batch

      @learned = learned?(@samples)
      
      @iteration += 1
      print_progress if @print_progress_flag
    end

    puts "n_p: #{@learing_rate_precondition}, n_c_ #{learing_rate_consequent}: error: #{@current_error}"
  end

  def stohastic_step(samples)
    samples.each do |sample|
      calculate_gradients(sample)
      update_params
    end
  end

  def batch_step(samples)
    samples.each do |sample|
      calculate_gradients(sample)
    end
    update_params
  end

  def output(sample)
    # i in index indicates current_rule, goes from 1 to m
    @rules.each do |rule|
      # A_i_x
      rule[:sigm_A_out] = sigmoidal_function(rule[:a][:val], rule[:b][:val], sample[:x])
      # B_i_y
      rule[:sigm_B_out] = sigmoidal_function(rule[:c][:val], rule[:d][:val], sample[:y])
      # w_i = t_norm(A_i_x, B_i_y)
      rule[:weight] = rule[:sigm_A_out] * rule[:sigm_B_out]
      # f_i = p_i * x + q_i * y + r_i
      rule[:out] = rule[:p][:val] * sample[:x] + rule[:q][:val] * sample[:y] + rule[:r][:val]
    end
    # sum(w_0...w_m), for each rule i
    weights_sum = @rules.map{ |rule| rule[:weight] }.sum
    # sum( w_i * f_i), for each rule i
    weights_outs_product_sum = @rules.map { |rule| rule[:weight] * rule[:out] }.sum
    # y = (w_1 * f_1 + ... + w_m * f_m) / (w_1 + ... w_m)
    weights_outs_product_sum / weights_sum
  end

  def update_params
    @rules.each do |rule|
      PARAMS.each do |param|
        param_der = @type == :stohastic ? rule[param][:der] : rule[param][:der] / @samples.count

        if SIGMOIDAL_PARAMS.include?(param)
          rule[param][:val] = rule[param][:val] - @learing_rate_precondition * param_der
        else
          rule[param][:val] = rule[param][:val] - @learing_rate_consequent * param_der
        end
      end
    end
    reset_derivatives
  end

  def calculate_gradients(sample)
    offset = output(sample) - sample[:z]

    weights_sum = @rules.map{ |rule| rule[:weight] }.sum

    @rules.each do |rule|

      partial_der_out_by_w = 0.0

      @rules.each do |rule2|
        partial_der_out_by_w += rule2[:weight] * (rule[:out] - rule2[:out])
      end
      partial_der_out_by_w = partial_der_out_by_w / (weights_sum**2)

      common_part_precondition = offset * partial_der_out_by_w  *  rule[:sigm_A_out] * rule[:sigm_B_out]
      common_part_consequent = offset * (rule[:weight]  / weights_sum )

      partial_der = {}
      partial_der[:a] = common_part_precondition * (1 - rule[:sigm_A_out]) * rule[:b][:val]
      partial_der[:b] = common_part_precondition * (1 - rule[:sigm_A_out]) * (rule[:a][:val] - sample[:x])
      partial_der[:c] = common_part_precondition * (1 - rule[:sigm_B_out]) * rule[:d][:val]
      partial_der[:d] = common_part_precondition * (1 - rule[:sigm_B_out]) * (rule[:c][:val] - sample[:y])

      partial_der[:p] = common_part_consequent * sample[:x]
      partial_der[:q] = common_part_consequent * sample[:y]
      partial_der[:r] = common_part_consequent

      if @type == :stohastic
        PARAMS.each do |param|
          rule[param][:der] = partial_der[param]
        end
      else
        PARAMS.each do |param|
          rule[param][:der] += partial_der[param]
        end
      end
    end
  end

  def learned?(samples)
    @current_error = calculate_error(samples) 
    if @current_error < @target_error
      puts "Learned :)"
      return true
    end

    false
  end

  def get_outputs_and_errors_for_samples(samples)
    outputs = []
    samples.each do |sample|
      out = output(sample)
      outputs << { x: sample[:x], y: sample[:y], z: out, err: sample[:z] - out}
    end

    outputs
  end

  private

  def reset_derivatives
    @rules.each do |rule|
      PARAMS.each do |param|
        rule[param][:der] = 0.0
      end
    end
  end

  def print_progress
    puts "Iteracija #{@iteration};\tTrenutna pogreška #{@current_error}" if @iteration % @status_every_n_iterations == 0
    binding.pry if @iteration % 100_000 == 0
  end

  def sigmoidal_function(a, b, x)
    1.0 / (1 + Math.exp(b * (x - a)))
  end

  def calculate_error(samples)
    error_sum = 0.0

    samples.each do |sample|
      out = self.output(sample)
      error_sum += (sample[:z] - out )**2
    end
    current_error = error_sum / samples.count
    @errors << current_error if @iteration % @save_error_every_n_iterations == 0
    
    current_error
  end
end 