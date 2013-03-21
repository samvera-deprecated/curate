#
# Tasks specific to CurateND
#

namespace :curatend do
  # don't define the ci stuff in production...since rspec is not available
  if defined?(RSpec)
    desc "Execute Continuous Integration build (docs, tests with coverage)"
    task :ci do
      ENV['RAILS_ENV'] = 'ci'
      Rails.env = 'ci'
      Rake::Task['environment'].invoke
      #Rake::Task["hyhead:doc"].invoke
      #Rake::Task["jetty:config"].invoke
      #Rake::Task["db:drop"].invoke
      #Rake::Task["db:create"].invoke
      Rake::Task['db:schema:load'].invoke

      Rake::Task['curatend:ci_spec'].invoke
      # I don't think we have any cucumber tests ATM
      #Rake::Task['cucumber'].invoke
    end

    RSpec::Core::RakeTask.new(:ci_spec) do |t|
      t.pattern = "./spec/**/*_spec.rb"
      t.rspec_opts = ['--tag ~js:true']
    end
  end
end
