module Mockdown
  module Model
    class Shape < UIObject
      attr_accessor :fill_alpha, :fill_color
      attr_accessor :stroke_alpha, :stroke_color, :stroke_thickness
    end

    class Line < UIObject
      attr_accessor :x1, :y1, :x2, :y2
      attr_accessor :alpha, :color, :thickness
    end

    class Circle < Shape
    end

    class Rect < Shape
      attr_accessor :border_radius
    end

    class Polygon < Shape
    end

    class Point
    end

    class Image < UIObject
    end
  end
end