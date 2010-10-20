# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'mockdown/version'

Gem::Specification.new do |s|
  s.name        = "mockdown"
  s.version     = Mockdown::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ben Johnson"]
  s.email       = ["benbjohnson@yahoo.com"]
  s.homepage    = "http://www.mkdn.org"
  s.summary     = "Design like a Hacker."
  #s.executables = ['mockdown']
  #s.default_executable = 'mockdown'

  s.add_development_dependency('rake', '~> 0.8.3')
  s.add_development_dependency('minitest', '~> 1.7.0')
  s.add_development_dependency('unindentable', '~> 0.0.3')

  s.test_files   = Dir.glob("test/**/*")
  s.files        = Dir.glob("lib/**/*") + %w(README.md)
  s.require_path = 'lib'
end
