require 'gnuplot'
require 'pry'
require_relative '../data/dataset.rb'

class Graph

  @@filepath = File.join(File.dirname(__FILE__), '../data/train-data.txt')

  def self.visualize_data(show_medians: false, show_learned_points: false, learned_points: [])
    dataset = DataSet.read_from_file(@@filepath)

    Gnuplot.open do |gp|
      Gnuplot::Plot.new(gp) do |plot|
        plot.xrange "[0:1]"
        plot.title  "Podaci"
        plot.xlabel "x"
        plot.ylabel "y"

        [:a, :b, :c].each do |sample_class|
          group = dataset.data.filter{ |sample| sample[:sample_class] == sample_class }
          
          plot.data << Gnuplot::DataSet.new( [group.map{ |sample| sample[:x]}, group.map{ |sample| sample[:y] } ]) do |ds|
            ds.with = "points"
            ds.title = "Klasa #{sample_class.to_s.capitalize}"
          end
        end

        if show_medians
          plot.data << Gnuplot::DataSet.new( [dataset.medians.map{ |m| m[0]}, dataset.medians.map{ |m| m[1]}] ) do |ds|
            ds.with = "points"
            ds.title = "Median"
          end
        end

        if show_learned_points
          plot.data << Gnuplot::DataSet.new( [learned_points.map{ |m| m[0]}, learned_points.map{ |m| m[1]}] ) do |ds|
            ds.with = "points"
            ds.title = "Learned"
          end
        end
      end
    end
  end
end

# Hidden layer values w1 & w2 on 2x8x3 architecture

# error = 0.0006
after_200k = [
    [0.12744940675971803, 0.25800376056420965],
    [0.125367664286357, 0.7466977789405045],
    [0.3771558605869623, 0.25010861150042285],
    [0.37058829732536175, 0.7464261847145941],
    [0.6281267749759264, 0.2510358481189615],
    [0.6217273088313406, 0.7474337157130838],
    [0.8746223668066849, 0.25262077551436185],
    [0.8743016867389503, 0.7414732176482753]
  ]
# error < 1e-7
after_700k = [
  [0.13097906082275665, 0.266266836074276],
  [0.12782407416328434, 0.7411576091786676],
  [0.37758105610934856, 0.26269457559122433],
  [0.3718463198904148, 0.7388380416781534],
  [0.6296473637793707, 0.26121674026931574],
  [0.6237505017641237, 0.7395735818485183],
  [0.8705504659125491, 0.25935166268711346],
  [0.8679498204047134, 0.7343524747531631]
]

Graph.visualize_data(
  show_medians: true,
  show_learned_points: true,
  learned_points: after_700k
)