#
# Tasks specific to Curate ND
#

namespace :curatend do
  desc "Execute Continuous Integration build (docs, tests with coverage)"
  task :ci => :environment do
    #Rake::Task["hyhead:doc"].invoke
    #Rake::Task["jetty:config"].invoke
    #Rake::Task["db:drop"].invoke
    #Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke

    Rake::Task['spec'].invoke
    Rake::Task['cucumber:ok'].invoke
    #raise "test failures: #{error}" if error
  end
end
