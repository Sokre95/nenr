def test_function(x,y)
  ((x - 1)**2 + (y + 2)**2 - 5*x*y + 3) * (Math.cos(x / 5.0))**2
end

def generate_samples
  samples = []

  (-4..4).each do |x|
    (-4..4).each do |y|
      samples << {x: x, y: y, z: test_function(x,y) }
    end
  end
  samples
end

def save_outputs_to_file(filename, samples)
  lines = ["#x y z"]  
  samples.each_with_index do |sample, i|
    lines << "" if i % 9 == 0 
    line = "#{sample[:x]} #{sample[:y]} #{sample[:z]}"
    lines << line
  end
  f = File.open(filename, "w+")
  f.write(lines.join("\n"))
  f.close
end

def save_errors_to_file(filename, samples)
  lines = ["#x y z"]  
  samples.each_with_index do |sample, i|
    lines << "" if i % 9 == 0 
    line = "#{sample[:x]} #{sample[:y]} #{sample[:err]}"
    lines << line
  end
  f = File.open(filename, "w+")
  f.write(lines.join("\n"))
  f.close
end
