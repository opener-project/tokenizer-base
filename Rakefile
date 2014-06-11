require 'bundler/gem_tasks'
require 'rake/clean'

CLEAN.include('tmp/*')

desc 'Runs the tests'
task :test do
  sh 'cucumber features'
end

task :default => :test
