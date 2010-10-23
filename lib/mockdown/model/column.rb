module Mockdown
  module Model
    # This class represents a layout container for laying out children in a
    # vertical column.
    class Column < VisualNode
      #########################################################################
      #
      # Public Methods
      #
      #########################################################################
    end
  end
end

Mockdown::Model.register('col', Mockdown::Model::Column)