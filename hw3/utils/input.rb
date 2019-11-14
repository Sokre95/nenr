module Input
  def self.values 
    @@values
  end

  def self.read 
    values_arr = ARGF.gets.strip.split(' ').map(&:to_i)
    @@values.keys.each_with_index { |key, index| @@values[key] = values_arr[index] }
  end

  private

  @@values = {
    L: 0,
    D: 0,
    LK: 0,
    DK: 0,
    V: 0,
    S: 0
  }
end