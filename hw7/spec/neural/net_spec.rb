require_relative '../../neural/net.rb'
require 'pry'

describe Neural::Net do

  context "2x2x1 net" do

    let(:net) { Neural::Net.construct([2,2,1])}
    let(:params) do
      params = [
        [1,1,1,1],
        [3,3,4,4],
        [1,1]

      ].flatten.map(&:to_f)
    end

    it "should return 0.8176.. value" do
      net.set_params(params)

      expect(net.forward([1,1]).first).to be_between(0.8175, 0.8176)
    end
  end
end
