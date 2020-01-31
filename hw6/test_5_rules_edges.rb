require_relative 'anfis.rb'
require_relative 'utils.rb'

samples = generate_samples

anfis = Anfis.new(5)

error_iteration = 1

anfis.train(
  type: :batch,
  samples: samples,
  max_iterations: 5000,
  print_progress_flag: true,
  status_every_n_iterations: 1,
  learing_rate_precondition: 0.00000000001,
  learing_rate_consequent: 0.000007,
  target_error: 1e-3,
  save_error_every_n_iterations: error_iteration
)

outputs_errors = anfis.get_outputs_and_errors_for_samples(samples)
save_outputs_to_file("./plot/test_5_out_edge.dat", outputs_errors)
save_errors_to_file("./plot/test_5_error_edge.dat", outputs_errors)

errors_file = File.open("errors_edge.dat", "w+")
errors_file.write(anfis.errors.each_with_index.map{ |er, i| "#{i * error_iteration} #{er}"}.join("\n"))

params_file = File.open("params_edge.dat", "w+")
params_file.write(anfis.rules.to_s)

errors_file.close
params_file.close