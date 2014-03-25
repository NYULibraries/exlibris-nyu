#!/usr/bin/env rake
require 'bundler/gem_tasks'

# Add test rake tasks and make them default
require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.test_files = FileList['test/*_test.rb', 
    'test/**/*_test.rb', 'test/**/**/*_test.rb']
  t.verbose = false
end
desc 'Default: run tests'
task :default => :test

# Add the RSpec rake tasks tasks and append to default
require 'rspec/core/rake_task'
desc 'Default: run specs'
task :default => :spec
desc "Run specs"
RSpec::Core::RakeTask.new

# We need to add the coveralls task in the Rakefile
# because we want to make sure we append it to the very
# end of the default task
if ENV['TRAVIS']
  # Add the coveralls task as the default with the appropriate prereqs
  require 'coveralls/rake/task'
  Coveralls::RakeTask.new
  desc 'Default: push to coveralls'
  task default: 'coveralls:push'
end
