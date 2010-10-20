lib = File.expand_path(File.dirname(__FILE__) + '/../lib')
$:.unshift lib unless $:.include?(lib)

require 'rubygems'
require 'minitest/autorun'
require 'mockdown'
require 'unindentable'

class MiniTest::Unit::TestCase
  include Unindentable
end
