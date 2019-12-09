class DataSetParser
  def self.parse(filename)
    File.open('./data/dataset1.txt').map do |line|
      values = line.split(' ').map(&:to_f)
      { x: values[0], y: values[1], f: values[2] }
    end
  end
end