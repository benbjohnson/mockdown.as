require File.dirname(__FILE__) + '/helper'

class TestBlockParser < MiniTest::Unit::TestCase
  ##############################################################################
  #
  # Setup
  #
  ##############################################################################
  def setup
    @parser = Mockdown::Parser::BlockParser.new()
  end


  ##############################################################################
  #
  # Helpers
  #
  ##############################################################################
  
  def assert_block(parent, level, line_number, content, child_count, block)
    assert_equal parent, block.parent, 'Block parent'
    assert_equal level, block.level, 'Block level'
    assert_equal line_number, block.line_number, 'Block line#'
    assert_equal content, block.content, 'Block content'
    assert_equal child_count, block.children.length, 'Block child count'
  end


  ##############################################################################
  #
  # Tests
  #
  ##############################################################################

  # Should return a single root node
  def test_parse_empty_file
    root = @parser.parse('')
    assert_equal 0, root.children.length
  end

  # Should return a root with a single child
  def test_parse_single_line
    root = @parser.parse(unindent(
      <<-BLOCK
        %foo abc=123
      BLOCK
    ))
    block = root.children.first
    assert_block nil, 0, nil, nil, 1, root
    assert_block root, 1, 1, '%foo abc=123', 0, block
  end
  
  # Should return a tree of blocks according to their nesting
  def test_parse_nested
    root = @parser.parse(unindent(
      <<-BLOCK
        %foo1
          %bar1
          %bar2
            %baz1

            %baz2

          %bar3
        %foo2
      BLOCK
    ))
    
    foo1, foo2 = *root.children
    bar1, bar2, bar3 = *foo1.children
    baz1, baz2 = *bar2.children

    assert_block root, 1, 1, '%foo1', 3, foo1
    assert_block root, 1, 9, '%foo2', 0, foo2
    assert_block foo1, 2, 2, '%bar1', 0, bar1
    assert_block foo1, 2, 3, '%bar2', 2, bar2
    assert_block foo1, 2, 8, '%bar3', 0, bar3
    assert_block bar2, 3, 4, '%baz1', 0, baz1
    assert_block bar2, 3, 6, '%baz2', 0, baz2
  end
end