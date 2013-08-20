module Curate
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    # An anonymous function that receives a path to a file
    # and returns AntiVirusScanner::NO_VIRUS_FOUND_RETURN_VALUE if no
    # virus is found; Any other returned value means a virus was found
    attr_accessor :default_antivirus_instance

    # When was this last built/deployed
    attr_accessor :build_identifier

    # Override characterization runner
    attr_accessor :characterization_runner

    def initialize
      @default_antivirus_instance = lambda {|file_path|
        AntiVirusScanner::NO_VIRUS_FOUND_RETURN_VALUE
      }
      # If you restart the server, this could be out of sync; A better
      # implementation is to read something from the file system. However
      # that detail is an exercise for the developer.
      @build_identifier = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    end
  end

  configure {}
end
