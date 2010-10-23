module Mockdown
  module Model
    # The base class for all visual objects within a mockdown document.
    class VisualNode < Node
      # The distance from the top of the parent node.
      attr_accessor :top

      # The distance from the bottom of the parent node.
      attr_accessor :bottom

      # The distance from the left of the parent node.
      attr_accessor :left

      # The distance from the right of the parent node.
      attr_accessor :right

      # The width of the node.
      attr_accessor :width

      # The height of the node.
      attr_accessor :height
    end
  end
end