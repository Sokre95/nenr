require_relative '../../neural/layer.rb'
require 'pry'

describe Neural::Layer do

  context "Sigmoidal layer" do

    let(:layer) { Neural::Layer.construct(2, 2, Neural::SigmoidalNeuron) }
    let(:params) { [ [1.0, 1.0],  [2.0, 2.0] ].flatten }

    it "should return 0.8176.. value" do
      layer.set_params(params)

      expect(layer.forward([1,1])[0]).to be_between(0.8807, 0.8808)
      expect(layer.forward([1,1])[1]).to be_between(0.9820, 0.9821)
    end
  end

  context "Input layer" do

    let(:layer) { Neural::Layer.construct(2, 1, Neural::IdentityNeuron) }

    it "should return 0.8176.. value" do
      expect(layer.forward(1)[0]).to eq(1.0)
      expect(layer.forward(2)[1]).to eq(2.0)
    end
  end
end
