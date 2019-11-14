require 'logger'

module FuzzyLogger
  def self.instance
    @@instance ||= Logger.new('fuzzy.log')
  end
end