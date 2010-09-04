module Mockdown
  module Model
    class Container < UIObject
      attr_accessor :children
    end

    class LayoutContainer < UIObject
      attr_accessor :spacing
      attr_accessor :padding
      attr_accessor :valign, :halign
    end

    class Row < LayoutContainer
    end

    class Column < LayoutContainer
    end

    class Canvas < Container
    end
  end
end