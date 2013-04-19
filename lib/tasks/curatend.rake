#
# Tasks specific to CurateND
#

namespace :curatend do
  # don't define the ci stuff in production...since rspec is not available
  if defined?(RSpec)
    namespace :jetty do
      JETTY_URL = 'https://github.com/ndlib/hydra-jetty/archive/xacml-updates-for-curate.zip'
      JETTY_ZIP = Rails.root.join('spec', JETTY_URL.split('/').last).to_s
      JETTY_DIR = 'jetty'

      task :download do
        puts "Downloading jetty..."
        system "curl -L #{JETTY_URL} -o #{JETTY_ZIP}"
        abort "Unable to download jetty from #{JETTY_URL}" unless $?.success?
      end

      task :unzip do
        puts "Unpacking jetty..."
        tmp_save_dir = Rails.root.join('spec', 'jetty_generator').to_s
        system "unzip -d #{tmp_save_dir} -qo #{JETTY_ZIP}"
        abort "Unable to unzip #{JETTY_ZIP} into #{tmp_save_dir}" unless $?.success?

        expanded_dir = Dir[File.join(tmp_save_dir, "hydra-jetty-*")].first
        system "mv #{expanded_dir} #{JETTY_DIR}"
        abort "Unable to move #{expanded_dir} into #{JETTY_DIR}/" unless $?.success?
      end

      task :clean do
        system "rm -rf #{JETTY_DIR}"
      end

      desc 'Download the appropriate jetty instance and install it with proper configuration'
      task :init => ["curatend:jetty:download", "curatend:jetty:clean", "curatend:jetty:unzip"]
    end

    desc 'Run specs on travis'
    task :travis do
      ENV['RAILS_ENV'] = 'ci'
      ENV['TRAVIS'] = true
      Rails.env = 'ci'
      # Rake::Task['curatend:jetty:download'].invoke
      Rake::Task['curatend:jetty:init'].invoke

      jetty_params = Jettywrapper.load_config
      error = Jettywrapper.wrap(jetty_params) do
        Rake::Task['curatend:ci'].invoke
      end
      raise "test failures: #{error}" if error
    end


    desc "Execute Continuous Integration build (docs, tests with coverage)"
    task :ci do
      ENV['RAILS_ENV'] = 'ci'
      Rails.env = 'ci'
      Rake::Task["db:drop"].invoke rescue true
      Rake::Task["db:create"].invoke
      Rake::Task['environment'].invoke
      #Rake::Task["hyhead:doc"].invoke
      #Rake::Task["jetty:config"].invoke
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
