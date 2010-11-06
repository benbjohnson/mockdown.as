module Mockdown
  VERSION = IO.read('build.xml').match(/<property name="version" value="(.+?)"\/>/)[1]
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
  
  # Commit
  sh "git commit --allow-empty -a -m 'v#{Mockdown::VERSION}'"
  sh "git tag v#{Mockdown::VERSION}"
  sh "git push origin master"
  sh "git push origin v#{Mockdown::VERSION}"
end
