#
# Tasks specific to CurateND
#

namespace :curatend do
  # don't define the ci stuff in production...since rspec is not available
  if defined?(RSpec)
    namespace :jetty do
      JETTY_URL = 'https://github.com/ndlib/hydra-jetty/archive/xacml-updates-for-curate.zip'
      JETTY_ZIP = File.join 'tmp', JETTY_URL.split('/').last
      JETTY_DIR = 'jetty'

      desc "download the jetty zip file"
      task :download do
        puts "Downloading jetty..."
        # system "cp -rf /Users/jfriesen/Repositories/hydra-jetty #{Rails.root.join(JETTY_DIR)}"
        system "curl -L #{JETTY_URL} -o #{JETTY_ZIP}"
        abort "Unable to download jetty from #{JETTY_URL}" unless $?.success?
      end

      task :unzip do
        # Rake::Task["jetty:download"].invoke unless File.exists? JETTY_ZIP
        puts "Unpacking jetty..."
        tmp_save_dir = File.join 'tmp', 'jetty_generator'
        system "unzip -d #{tmp_save_dir} -qo #{JETTY_ZIP}"
        abort "Unable to unzip #{JETTY_ZIP} into tmp_save_dir/" unless $?.success?

        expanded_dir = Dir[File.join(tmp_save_dir, "hydra-jetty-*")].first
        system "mv #{expanded_dir} #{JETTY_DIR}"
        abort "Unable to move #{expanded_dir} into #{JETTY_DIR}/" unless $?.success?
      end

      task :clean do
        system "rm -rf #{JETTY_DIR}"
      end

      task :configure_solr do
        cp('solr_conf/solr.xml', File.join(JETTY_DIR, 'solr/development-core'), verbose: true)
        cp('solr_conf/solr.xml', File.join(JETTY_DIR, 'solr/test-core/'), verbose: true)
        FileList['solr_conf/conf/*'].each do |f|
          cp("#{f}", File.join(JETTY_DIR, 'solr/development-core/conf/'), :verbose => true)
          cp("#{f}", File.join(JETTY_DIR, 'solr/test-core/conf/'), :verbose => true)
        end
      end

      task :configure_fedora do
        cp('fedora_conf/conf/development/fedora.fcfg', File.join(JETTY_DIR, 'fedora/default/server/config/'), verbose: true)
        cp('fedora_conf/conf/test/fedora.fcfg', File.join(JETTY_DIR, 'fedora/test/server/config/'), verbose: true)
      end

    end

    desc 'Run specs on travis'
    task :travis do
      ENV['RAILS_ENV'] = 'ci'
      Rails.env = 'ci'
      Rake::Task['environment'].invoke
      Rake::Task['curatend:jetty:download'].invoke
      Rake::Task['curatend:jetty:clean'].invoke
      Rake::Task['curatend:jetty:unzip'].invoke
      Rake::Task['curatend:jetty:configure_solr'].invoke
      Rake::Task['curatend:jetty:configure_fedora'].invoke

      jetty_params = Jettywrapper.load_config
      error = Jettywrapper.wrap(jetty_params) do
        ENV['COVERAGE'] = 'true'
        Rake::Task['curatend:ci'].invoke
      end
      raise "test failures: #{error}" if error
    end


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
