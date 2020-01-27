class DataSet

  attr_reader :data

  INDEX_TO_CLASS_MAPINGS = [:a, :b, :c]

  def self.read_from_file(filepath)
    file_content = File.read(filepath)

    data = file_content.split("\n").map do |train_sample|
      x,y = train_sample.split("\t")[0..1].map(&:to_f)
      classification_index_array = train_sample.split("\t")[2..4].map(&:to_i)
      sample_class = INDEX_TO_CLASS_MAPINGS[classification_index_array.index(1)] 

      {
        x: x, y: y, sample_class: sample_class, classification: classification_index_array.map(&:to_f)
      }
    end

    self.new(data)
  end

  def medians
    [
      [0.125, 0.25], [0.375, 0.25], [0.625, 0.25], [0.875, 0.25],
      [0.125, 0.75], [0.375, 0.75], [0.625, 0.75], [0.875, 0.75]
    ]
  end

  private

  def initialize(data)
    @data = data
  end
end