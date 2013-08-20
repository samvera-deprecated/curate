require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root File.expand_path("../../../../support", __FILE__)

  def run_blacklight_generator
    say_status("warning", "GENERATING BL", :yellow)

    generate 'blacklight', '--devise'
  end

  def run_hydra_head_generator
    say_status("warning", "GENERATING HH", :yellow)

    generate 'hydra:head', '-f'
  end

  def run_sufia_models_generator
    say_status("warning", "GENERATING SUFIA-MODELS", :yellow)

    generate 'sufia:models:install', '-f'

    remove_file 'spec/factories/users.rb'
  end

  def run_curate_generator
    say_status("warning", "GENERATING CURATE", :yellow)

    generate 'curate', '-f'

    initializer 'curate_initializer.rb' do
      <<-EOV
      Curate.configure do |config|
        config.default_antivirus_instance = lambda {|file_path|
          AntiVirusScanner::NO_VIRUS_FOUND_RETURN_VALUE
        }
      end
      EOV
    end

  end

end
