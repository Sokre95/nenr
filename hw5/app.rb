require_relative "./ui.rb"
require_relative "./neural/net.rb"
require_relative "./neural/functions.rb"


if __FILE__ == $0

  nn = Neural::Net.construct(
    [20, 8, 6, 5],
    Neural::ActivationFunctions.sigmoid,
    Neural::ErrorFunctions.mse
  )

  application = FXApp.new
  app_window = AppWindow.new(application, nn)

  application.create
  application.run
end