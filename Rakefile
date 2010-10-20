require 'rubygems'
require 'rake'
require 'minitest/autorun'
require 'rake/testtask'
require 'cucumber/rake/task'
require 'rake/rdoctask'

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

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--format progress"
end

desc "Generate RCov test coverage and open in your browser"
task :coverage do
  require 'rcov'
  sh "rm -fr coverage"
  sh "rcov test/test_*.rb"
  sh "open coverage/index.html"
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "#{name} #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/#{name}.rb"
end

#############################################################################
#
# Custom tasks (add your own tasks here)
#
#############################################################################


#############################################################################
#
# Packaging tasks
#
#############################################################################

# TODO: Define version
task :release => :build do
  unless `git branch` =~ /^\* master$/
    puts "You must be on the master branch to release!"
    exit!
  end
  sh "git commit --allow-empty -a -m 'v#{version}'"
  sh "git tag v#{version}"
  sh "git push origin master"
  sh "git push origin v#{version}"
  sh "gem push mockdown-#{version}.gem"
end

task :build do
  sh "mkdir -p pkg"
  sh "gem build mockdown-#{version}.gem"
end
