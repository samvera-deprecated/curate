#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

CurateNd::Application.load_tasks

task :test_setup do
  ENV['RAILS_ENV'] = 'test'
  Rails.env = 'test'
  Rake::Task['environment'].invoke
  Rake::Task['db:schema:load'].invoke

end
desc "run all of the specs"
task :rspec => :test_setup do
  RSpec::Core::RakeTask.new(:__rspec) do |t|
    t.pattern = "./spec/**/*_spec.rb"
  end
  Rake::Task['__rspec'].invoke
end

task :default => :rspec


task :stats => :test_setup
STATS_DIRECTORIES << %w(Workers                 app/workers)
STATS_DIRECTORIES << %w(Services                app/services)
STATS_DIRECTORIES << %w(RepoModels              app/repository_models)
STATS_DIRECTORIES << %w(RepoDatastreams         app/repository_datastreams)
STATS_DIRECTORIES << %w(Inputs                  app/inputs)
STATS_DIRECTORIES << %w(Mailers                 app/mailers)