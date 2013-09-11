# Run rake tasks from my_gem once it's installed.
#
# Example:
#   my_gem rake some-task
#   my_gem rake some-task[args]
#
# Author:: N David Brown
gem_dir = File.expand_path("..", File.dirname(__FILE__))
$LOAD_PATH.unshift gem_dir # Look in gem directory for resources first.
require 'rake'
require 'pp'
pwd = Dir.pwd
Dir.chdir(gem_dir) # We'll load rakefile from the gem's dir.
Rake.application.init
Rake.application.load_rakefile
Dir.chdir(pwd) # Revert to original pwd for any path args passed to task.
Rake.application.invoke_task(ARGV.first)