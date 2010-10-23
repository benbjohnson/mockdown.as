module Mockdown
  module Model
    # The base class for all Mockdown model classes. Contains basic file and
    # block references.
    class Node
      #########################################################################
      #
      # Public Methods
      #
      #########################################################################
      
      def initialize(block=nil)
        self.block  = block
        @children = []
      end
      
      # The parent of the node.
      attr_accessor :parent

      # The name of the node
      attr_accessor :name

      # The original block the node was parsed from.
      attr_accessor :block
      
      # An Array of child nodes contained within this node.
      attr_accessor :children
      
      # The document that this node was parsed from. If the document is
      # not explicitly then it attempts to find the document on the parent node.
      def document()
        if @document
          return @document
        elsif parent
          return parent.document
        else
          return nil
        end
      end
      
      def document=(value)
        @document = value
      end
      
      # A flag stating if this node is the document root.
      def root?
        @document.nil?
      end
    end
  end
end