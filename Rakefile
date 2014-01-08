require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

desc 'Run RSpec examples (all)'

RSpec::Core::RakeTask.new(:spec)

namespace :spec do

  desc 'Run RSpec core examples'

  RSpec::Core::RakeTask.new(:core) do |task|
    task.pattern = "./spec/**/*_spec.rb"
    task.rspec_opts = '--tag core'
  end

  desc 'Run additional RSpec examples (e.g., integration specs)'

  RSpec::Core::RakeTask.new(:more) do |task|
    task.pattern = "./spec/**/*_spec.rb"
    task.rspec_opts = '--tag more'
  end

end

task default: :spec
task test:    :spec
