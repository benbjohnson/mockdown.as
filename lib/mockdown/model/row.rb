module Mockdown
  module Model
    # This class represents a layout container for laying out children in a
    # horizontal row.
    class Row < VisualNode
      #########################################################################
      #
      # Public Methods
      #
      #########################################################################
    end
  end
end

Mockdown::Model.register('row', Mockdown::Model::Row)