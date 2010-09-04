module Mockdown
  module Model
    class Object
    end

    class UIObject < Object
      attr_accessor :top, :bottom, :left, :right
      attr_accessor :width, :height
    end
  end
end