module Mockdown
  module Model
    # This class represents a text node in a Mockdown document.
    class Text < VisualNode
      #########################################################################
      #
      # Public Methods
      #
      #########################################################################
      
      # The text displayed by the node.
      attr_accessor :value
    end
  end
end

Mockdown::Model.register('text', Mockdown::Model::Text)