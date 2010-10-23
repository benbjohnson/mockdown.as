require 'mockdown/parser/block'
require 'mockdown/parser/block_parser'
require 'mockdown/parser/errors'

module Mockdown
  # The parser parses the structure of a mockdown file and converts it into
  # the Mockdown model objects. Mockdown files consist of a series of nested,
  # white-space aware tags organized into a document. Tags can reference other
  # mockdown files or mockdown primitives such as lines, rects and text.
  class Parser
    #########################################################################
    #
    # Constants
    #
    #########################################################################

    EXTENSIONS = ['mkd', 'mkx']
    

    #########################################################################
    #
    # Public Methods
    #
    #########################################################################

    # Public: Creates a new Mockdown parser instance.
    def initialize()
      @load_path = []
      @block_parser = Mockdown::Parser::BlockParser.new()
    end

    # Public: An Array of paths to load mockdown files from.
    attr_accessor :load_path

    # Public: Parses a mockdown document into a mockdown document.
    #
    # filename - The path of the file to parse.
    #
    # Example:
    #
    #   parser = Mockdown::Parser.new()
    #   root   = parser.parse('homepage.mkdn')
    #
    # Returns a Mockdown::Model::Document
    def parse(filename, options={})
      file = find_file(filename)
      
      # Validate file exists.
      raise ParseError.new(0, "Filename is required: #{filename}") if file.nil?
      raise ParseError.new(0, "File does not exist: #{file}") if file.nil?
      raise ParseError.new(0, "File is not readable: #{file}") unless File.readable?(file)
      
      # Read file and parse into blocks
      content = IO.read(file)
      root = block_parser.parse(content)

      # Create the document
      document = Mockdown::Model::Document.new()
      document.file = file

      # TODO: Parse pragmas
      
      # Recursively parse from root block
      if node = parse_block(root.children.first)
        node.document = document
      end
      
      return node
    end
    

    #########################################################################
    #
    # Protected Methods
    #
    #########################################################################

    protected
    
    # The block parser used when parsing.
    attr_reader :block_parser
    
    # Parses an individual node and attaches it to the tree.
    #
    # block - The block to parse.
    #
    # Returns a Mockdown::Model::Node.
    def parse_block(block)
      return nil if block.nil?

      node = nil

      # If it starts with a percent sign then parse as a single line
      if block.content.index('%') == 0
        m, name, values = *block.content.match(/^%(\S+)(?:\s+(.+))?/)
        
        # Attempt to find system component
        node = Mockdown::Model.create(name)

        # TODO: Merge blocks from current document and nested document

        # If no system component found, find file of given name and parse
        node = parse(name) if node.nil?

        node.name = name
        parse_values(node, values)

      # Otherwise parse as Markdown
      else
        node = Mockdown::Model.create('text')
        node.value = block.content.gsub(/\n|\t/, ' ')
      end

      # Assign block to node
      node.block = block

      # Loop over children and parse blocks
      block.children.each do |child_block|
        child_node = parse_block(child_block)
        child_node.parent = node
        node.children << child_node
      end
      
      return node
    end

    # Parses a value string and assigns the values to a node.
    #
    # node   - The node to assign values to.
    # values - The space-separated value string to parse.
    #
    # Returns nothing.
    def parse_values(node, values)
      if !values.nil?
        # Group together quotes values
        pairs = split_quoted_pairs(values)
        
        pairs.each do |pair|
          m, k, v = *pair.match(/^(.+?)=(.+)$/)
          v.gsub!(/^"|"$/, '')
          node.__send__("#{k}=", v)
        end
      end
    end
    
    # Splits a space-separated string of key-value pairs so that values are
    # appropriately grouped with double quotes.
    def split_quoted_pairs(str)
      # HACK: This is a poor mans way of parsing quoted value pairs. It doesn't
      #       account for errors like starting a value line with a double quote.
      pairs = []
      quote = nil
      str.split(/\s+/).each do |token|
        if quote
          pairs[pairs.length-1] += " #{token}"
          quote = nil unless token.index(/"$/).nil?
        else
          pairs << token
          quote = '"' if token.index(/^\w+="/)
        end
      end
      pairs
    end
    
    # Searches the load path for a given file.
    # 
    # filename - The name of the file to search for.
    #
    # Returns 
    def find_file(filename)
      load_path.each do |path|
        EXTENSIONS.each do |ext|
          file = File.expand_path(File.join("#{path}/#{filename}.#{ext}"))
          return file if File.exists?(file)
        end
      end
    end
  end
end