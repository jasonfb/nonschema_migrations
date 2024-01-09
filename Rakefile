
require "rubygems"
require "bundler/setup"

require 'rake/testtask'

require 'byebug'

require "minitest/test_task"


Minitest::TestTask.create :test do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.libs << 'lib/generators'
  t.libs << 'lib/tasks'
  t.libs << 'lib/nonschema_migrations'
  t.test_globs  = 'test/**/*_test.rb'
  t.warning = false
end

desc "Run tests"
task :default => :test

task :console do
  require 'irb'
  require 'irb/completion'
  require 'nonschema_migrations'
  ARGV.clear
  IRB.start
end


