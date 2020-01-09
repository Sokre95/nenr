require 'pry'
require_relative './app_data'

class Gesture

  IDENTIFIERS = {
    alfa:   "1,0,0,0,0",
    beta:   "0,1,0,0,0",
    gamma:  "0,0,1,0,0",
    delta:  "0,0,0,1,0",
    epsilon:"0,0,0,0,1"
  }

  attr_reader :representatives, :representative_points

  def initialize(raw_gesture_points) 
    @raw_gesture_points = raw_gesture_points
    extractor = GestureExtractor.new(raw_gesture_points)

    @representatives = extractor.extract_representatives
    @representative_points = extractor.calculate_representative_points
  end

  def save_to_file(letter)
    file = File.open(AppData.train_data_file_name, 'a+')
    file.write(representatives.join(',') +  " " + IDENTIFIERS[letter])
    file.write("\n")
    file.flush
    file.close
  end
end

class GestureExtractor

  M_POINTS = AppData.input_dots_M

  def initialize(raw_gesture_points)
    @raw_gesture_points = raw_gesture_points
  end

  def extract_representatives
    @median_point = points_median(@raw_gesture_points)
    translated_points = translate_points(@raw_gesture_points, @median_point)
    @scaling_factor = find_max(translated_points)
    scaled_points = scale_points(translated_points, @scaling_factor)

    dist = calculate_distance(scaled_points)

    @representatives = calculate_representatives(scaled_points, dist, M_POINTS)
  end

  def calculate_representative_points
    extract_representatives unless @representatives

    # 'recreate' points by unscaling and detranslating
    @representative_points = @representatives.map do |point|
      #unscale
      point = [point[0] * @scaling_factor, point[1] * @scaling_factor]
      #detranslate
      point = [point[0] + @median_point[0], point[1] + @median_point[1]]
    end
  end

  private

  def distance(point1, point2)
    x_diff = point1[0] - point2[0]
    y_diff = point1[1] - point2[1]

    Math.sqrt(x_diff**2 + y_diff**2)
  end

  def points_median(points)
    sum_x, sum_y = 0, 0

    points.each do |point|
      sum_x += point[0]
      sum_y += point[1]
    end

    [sum_x.to_f / points.size, sum_y.to_f / points.size]
  end

  def translate_points(points, median_point)
    points.map do |point|
      [
        point[0] - median_point[0],
        point[1] - median_point[1]
      ]
    end
  end

  def interpolate_points(point1, point2)
    [
      (point1[0] + point2[0]) / 2,
      (point1[1] + point2[1]) / 2
    ]
  end

  def find_max(points)
    points.map { |point| point.max }.max
  end

  def scale_points(points, factor)
    points.map{ |point| [point[0] / factor, point[1] / factor ] }
  end

  def calculate_distance(points)
    dist = 0.0
    point1 = points[0]

    points[1..-1].each do |point2|
      dist += distance(point1, point2)
      point1 = point2
    end

    dist
  end

  def calculate_representatives(points, dist, m_points)
    first = points[0]
    rep_points = [first]

    (1..(m_points-1)).each do |k|
      distance_k = (k * dist) / (m_points - 1)
      current_point = first
      current_distance = 0.0
      i = 0

      while current_distance <= distance_k && i < points.size - 1
        i += 1
        current_distance += distance(current_point, points[i])
        current_point = points[i]
      end

      if current_distance == distance_k
        rep_points << current_point 
      else
        rep_points << interpolate_points(points[i - 1], points[i])
      end
    end

    rep_points
  end
end