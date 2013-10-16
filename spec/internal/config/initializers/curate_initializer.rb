      Curate.configure do |config|
        config.default_antivirus_instance = lambda {|file_path|
          AntiVirusScanner::NO_VIRUS_FOUND_RETURN_VALUE
        }
        config.characterization_runner = lambda {|file_path|
          Curate::Engine.root.join('spec/support/files/default_fits_output.xml').read
        }
      end
