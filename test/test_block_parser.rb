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

  # Should join multiple lines together unless they start with a single line
  # character (% or !).
  def test_parse_multiline
    root = @parser.parse(unindent(
      <<-BLOCK
        !pragma1
        !pragma2
        
        %foo
          This is a test
          of a multiline
          block.
          
          This is another 
          block.
          
          One more block
          %bar
      BLOCK
    ))
    
    pragma1, pragma2, foo = *root.children
    b1, b2, b3, bar = *foo.children

    assert_block root, 1, 1, '!pragma1', 0, pragma1
    assert_block root, 1, 2, '!pragma2', 0, pragma2
    assert_block root, 1, 4, '%foo', 4, foo
    assert_block foo, 2, 5, "This is a test\nof a multiline\nblock.", 0, b1
    assert_block foo, 2, 9, "This is another\nblock.", 0, b2
    assert_block foo, 2, 12, "One more block", 0, b3
    assert_block foo, 2, 13, "%bar", 0, bar
  end
end