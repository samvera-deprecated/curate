#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Curate'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Dir.glob('tasks/*.rake').each { |r| import r }

Bundler::GemHelper.install_tasks

if !ENV['TRAVIS']
  require 'rspec/yenta'
  RSpec::Yenta.load_tasks do
    require File.expand_path("../spec/internal/config/environment.rb",  __FILE__)
    require File.expand_path('../spec/matchers', __FILE__)
  end
  task :yenta => 'generate'
end

task :default => 'ci'
