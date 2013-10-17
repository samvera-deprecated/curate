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

task :default => 'ci'

task :release => ['release:update_template']

namespace :release do

  desc 'Make sure the application template is updated'
  task :update_template do
    application_template_directory = File.expand_path("../lib/generators/curate/", __FILE__)
    application_template_erb = File.join(application_template_directory, "application_template.rb.erb")
    application_template_output = File.join(application_template_directory, "application_template.rb")
    buffer = ERB.new(File.read(application_template_erb)).result(binding)
    File.open(application_template_output, 'w+') do |file|
      file.puts buffer
    end
  end
end
