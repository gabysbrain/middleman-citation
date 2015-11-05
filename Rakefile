require 'bundler'
Bundler::GemHelper.install_tasks

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:cucumber, 'Run features that should pass') do |t|
  t.cucumber_opts = "--color --tags ~@wip --strict"
end

require 'rspec/core/rake_task'
desc "Run RSpec"
RSpec::Core::RakeTask.new do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--color', '--format documentation']
end

require 'rake/clean'

task test: ['spec', 'cucumber']

task default: :test
