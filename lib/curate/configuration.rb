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
    def initialize
      @default_antivirus_instance =     lambda {|file_path|
        AntiVirusScanner::NO_VIRUS_FOUND_RETURN_VALUE
      }
    end
  end

  configure {}
end
