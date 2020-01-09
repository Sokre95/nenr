module AppData
  @@train_data_filename = 'train.in'
  @@M = 10

  def self.train_data_file_name
    @@train_data_filename
  end

  def self.input_dots_M
    @@M
  end

  def self.batch_size
    10
  end

  def self.learning_rate
    0.005
  end

  def self.max_iterations
    25_000
  end
end