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
    # I don't think we have any cucumber tests ATM
    #Rake::Task['cucumber'].invoke
  end
end
