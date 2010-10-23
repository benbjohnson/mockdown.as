require File.dirname(__FILE__) + '/helper'

class TestParser < MiniTest::Unit::TestCase
  ##############################################################################
  #
  # Setup
  #
  ##############################################################################

  def setup
    @parser = Mockdown::Parser.new()
    @parser.load_path << File.expand_path(File.dirname(__FILE__) + '/mockups')
  end


  ##############################################################################
  #
  # Tests
  #
  ##############################################################################

  # Should return a single document node
  def test_parse_empty_file
    assert_nil @parser.parse('empty')
  end

  # Should parse a self-contained, system component-only document.
  def test_parse_simple_file
    root = @parser.parse('simple')

    # Verify root col
    assert root.is_a?(Mockdown::Model::Column)
    assert_equal 3, root.children.length
    assert root.document.is_a?(Mockdown::Model::Document)
    assert_equal File.expand_path('test/mockups/simple.mkd'), root.document.file
    
    # Verify all children of the column
    text, h2, p = *root.children
    assert text.is_a?(Mockdown::Model::Text)
    assert_equal 'Welcome to Nevada!', text.value
    assert_equal root.document, text.document
    assert h2.is_a?(Mockdown::Model::Text)
    assert_equal '## Las Vegas', h2.value
    assert_equal root.document, h2.document
    assert p.is_a?(Mockdown::Model::Text)
    assert_equal 'Please spend all your money here.', p.value
    assert_equal root.document, p.document
  end

  # Should parse a complex, multi-file document.
  def test_parse_complex_file
    root = @parser.parse('complex')
    
    # Verify root col
    assert root.is_a?(Mockdown::Model::Column)
    assert_equal File.expand_path('test/mockups/complex.mkd'), root.document.file
    
    header = *root.children
    assert header.is_a?(Mockdown::Model::Row)
    assert_equal '200', header.width
    assert_equal '30', header.height
    assert_equal '10', header.top
    assert_equal File.expand_path('test/mockups/header.mkx'), header.document.file
    assert_equal 2, header.children.length
    
    h2, text = *header.children
    assert_equal header.document, h2.document
  end
end