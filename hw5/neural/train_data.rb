module Neural
  class TrainData

    attr_reader :data

    def self.read_from_file(filename)
      file_content = File.read(filename)

      train_data = file_content.split("\n").map do |train_sample|
        inputs = train_sample.split(" ")[0].split(',').map(&:to_f)
        outputs = train_sample.split(" ")[1].split(',').map(&:to_f)
        {
          inputs: inputs,
          expected_outputs: outputs
        }
      end

      self.new(train_data.shuffle)
    end

    def next_batch(batch_size)
      batch = @data[@last_batch_index..(@last_batch_index + batch_size - 1)]
      @last_batch_index = (@last_batch_index + batch_size) % @data.size

      batch
    end

    private

    def initialize(train_data)
      @data = train_data
      @last_batch_index = 0
    end
  end
end