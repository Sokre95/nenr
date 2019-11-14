require_relative '../../hw1/operations'
require 'pry'

module Fuzzy
  class Rule

    attr_reader :t_norm, :implication, :antecedents, :consequent

    def initialize(t_norm, implication)
      @t_norm = t_norm
      @implication = implication
      @antecedents = []
      @consequent = nil
    end

    def add_antecedent(proposition)
      @antecedents << proposition
      self
    end

    def add_consequent(proposition)
      @consequent = proposition
      self
    end

    def evaluate(values)
      res = 1.0
      antecedents.each { |antecedent| res = t_norm.call(res, antecedent.get_affiliation(values)) }
      Operations.unary_operation(consequent.fuzzy_set, lambda { |value| implication.call(res, value) } )
    end
  end
end