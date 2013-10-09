require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root File.expand_path("../../../../skeleton", __FILE__)

  def run_curate_generator
    say_status("warning", "GENERATING CURATE", :yellow)

    generate 'curate', '-f --with-doi'

    gsub_file('config/environments/test.rb', /^.*config\.consider_all_requests_local.*$/) do |match|
      match = "  # For end to end specs, I want the exception handler capturing things; Not raising exceptions.\n  config.consider_all_requests_local = ENV['LOCAL'] || false"
    end

    initializer 'curate_initializer.rb' do
      <<-EOV
      Curate.configure do |config|
        config.default_antivirus_instance = lambda {|file_path|
          AntiVirusScanner::NO_VIRUS_FOUND_RETURN_VALUE
        }
        config.characterization_runner = lambda {|file_path|
          Curate::Engine.root.join('spec/support/files/default_fits_output.xml').read
        }
      end
      EOV
    end
  end
end
