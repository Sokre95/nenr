require_relative '../../neural/neuron.rb'
require 'pry'

RSpec.describe "Nerons" do

  describe Neural::IdentityNeuron do
    describe "#forward" do
      it "should calculate correct output for single input" do
        neuron = Neural::IdentityNeuron.new(1, [1])
        expect(neuron.forward(1)).to eq(1)
      end
    end

    describe "#num_of_params" do
      it "should return 0" do
        neuron = Neural::IdentityNeuron.new(1, [1])
        expect(neuron.num_of_params).to eq(0)
      end
    end
  end

  describe Neural::SigmoidalNeuron do
    describe "#forward" do
      it "should calculate correct output for single input" do
        neuron = Neural::SigmoidalNeuron.new(1, [1])
        expect(neuron.forward([1])).to be_between(0.731, 0.732)
      end

      it "should calculate correct output for mutliple input" do
        neuron = Neural::SigmoidalNeuron.new(2, [1,1])
        expect(neuron.forward([1,1])).to be_between(0.880, 0.881)
      end
    end
  end

  describe Neural::Type1Neuron do
    describe "#forward" do
      it "should calculate correct output for single input" do
        neuron = Neural::Type1Neuron.new(1, [1,1])
        expect(neuron.forward([1])).to eq(1)
      end

      it "should calculate correct output for mutliple input" do
        neuron = Neural::Type1Neuron.new(2, [2,2,2,2])
        expect(neuron.forward([5,5])).to be_between(0.33, 0.34)
      end
    end

    describe "#num_of_params" do
      it "should return 4 for type 1 neuron with 2 inputs" do
        neuron = Neural::Type1Neuron.new(2, [2,2,2,2])
        expect(neuron.num_of_params).to eq(4)
      end
    end
  end
end