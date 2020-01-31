require_relative 'anfis.rb'
require_relative 'utils.rb'

samples = generate_samples

anfis = Anfis.new(1)

anfis.train(
  type: :stohastic,
  samples: samples,
  max_iterations: 10_000,
  print_progress_flag: true,
  status_every_n_iterations: 100,
  learing_rate_precondition: 0.0007,
  learing_rate_consequent: 0.01,
  target_error: 1e-4,
  save_error_every_n_iterations: 100
)

outputs_errors = anfis.get_outputs_and_errors_for_samples(samples)
save_outputs_to_file("./plot/test_1_out_stoh.dat", outputs_errors)
save_errors_to_file("./plot/test_1_error_stoh.dat", outputs_errors)