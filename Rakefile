lib = File.expand_path(File.dirname(__FILE__) + '/lib')
$:.unshift lib unless $:.include?(lib)

require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'mockdown'

#############################################################################
#
# Standard tasks
#
#############################################################################
  
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

Rake::RDocTask.new do |rd|
  rd.main = 'README.md'
  rd.rdoc_files.include('README.md', 'lib/**/*.rb')
  rd.rdoc_dir = 'doc'
  rd.title = 'Mockdown Documentation'
end


#############################################################################
#
# Packaging tasks
#
#############################################################################

task :release do
  puts ""
  print "Are you sure you want to relase Mockdown #{Mockdown::VERSION}? [y/N] "
  exit unless STDIN.gets.index(/y/i) == 0
  
  unless `git branch` =~ /^\* master$/
    puts "You must be on the master branch to release!"
    exit!
  end
  
  # Build gem and upload
  sh "gem build mockdown.gemspec"
  sh "gem push mockdown-#{Mockdown::VERSION}.gem"
  sh "rm mockdown-#{Mockdown::VERSION}.gem"
  
  # Commit
  sh "git commit --allow-empty -a -m 'v#{Mockdown::VERSION}'"
  sh "git tag v#{Mockdown::VERSION}"
  sh "git push origin master"
  sh "git push origin v#{Mockdown::VERSION}"
end
