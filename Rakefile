#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

CurateNd::Application.load_tasks

desc "run all of the specs"
task :rspec do
  ENV['RAILS_ENV'] = 'test'
  Rails.env = 'test'
  Rake::Task['environment'].invoke
  RSpec::Core::RakeTask.new(:__rspec) do |t|
    t.pattern = "./spec/**/*_spec.rb"
  end
  Rake::Task['__rspec'].invoke
end

task :default => :rspec