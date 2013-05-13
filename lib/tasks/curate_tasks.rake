namespace :curate do
  if defined?(RSpec)
    def system_with_command_output(command)
      puts("\n$\t#{command}")
      system(command)
    end
    namespace :jetty do
      JETTY_URL = 'https://github.com/ndlib/hydra-jetty/archive/curate-without-xacml-alterations.zip'
      JETTY_ZIP = Rails.root.join('spec', JETTY_URL.split('/').last).to_s
      JETTY_DIR = Rails.root.join('jetty').to_s

      task :download do
        puts "Downloading jetty..."
        if File.exist?(JETTY_ZIP)
          puts "File already exists, moving on..."
        else
          system_with_command_output "curl -L #{JETTY_URL} -o #{JETTY_ZIP}"
          abort "Unable to download jetty from #{JETTY_URL}" unless $?.success?
        end
      end

      task :unzip do
        puts "Unpacking jetty..."
        tmp_save_dir = Rails.root.join('spec', 'jetty_generator').to_s
        system_with_command_output "unzip -d #{tmp_save_dir} -qo #{JETTY_ZIP}"
        abort "Unable to unzip #{JETTY_ZIP} into #{tmp_save_dir}" unless $?.success?

        expanded_dir = Dir[File.join(tmp_save_dir, "hydra-jetty-*")].first
        system_with_command_output "mv #{File.join(expanded_dir, '/*')} #{JETTY_DIR}"
        abort "Unable to move #{expanded_dir} into #{JETTY_DIR}/" unless $?.success?
      end

      task :clean do
        system_with_command_output "rm -rf #{JETTY_DIR} && mkdir -p #{JETTY_DIR}"
      end

      desc 'Download the appropriate jetty instance and install it with proper configuration'
      task :init => ["app:curate:jetty:download", "app:curate:jetty:clean", "app:curate:jetty:unzip"]
    end

    desc 'Run specs on travis'
    task :travis do
      ENV['RAILS_ENV'] = 'test'
      ENV['TRAVIS'] = '1'
      Rails.env = 'test'
      Rake::Task['app:curate:jetty:init'].invoke

      require 'jettywrapper'
      jetty_params = Jettywrapper.load_config
      error = Jettywrapper.wrap(jetty_params) do
        Rake::Task['app:curate:test'].invoke
      end
      raise "test failures: #{error}" if error
    end


    RSpec::Core::RakeTask.new(:test_spec) do |t|
      t.pattern = "./spec/**/*_spec.rb"
      t.rspec_opts = ['--tag ~js:true']
    end

    desc "Execute Continuous Integration build (docs, tests with coverage)"
    task :test do
      ENV['RAILS_ENV'] = 'test'
      Rails.env = 'test'
      Rake::Task["db:drop"].invoke rescue true
      Rake::Task["db:create"].invoke
      Rake::Task['environment'].invoke
      Rake::Task['db:schema:load'].invoke

      Rake::Task['app:curate:test_spec'].invoke
    end

  end
end
