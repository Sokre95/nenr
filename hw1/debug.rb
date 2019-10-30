module Debug
  def self.print_domain(domain, header)
    puts header if header
    domain.each do |domain_element|
      puts "\tElement domene: #{domain_element.to_s}"
    end
    puts "Kardinalitet domene je: #{domain.get_cardinality}"
  end

  def self.print_set(set, header)
    puts header if header
    set.get_domain.each do |domain_element|
      puts "d(#{domain_element})=#{set.get_value_at(domain_element)}"
    end
  end
end