require 'morphine'
module Curate
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    include Morphine

    register :user_create_callback do
      Curate::Service::UserCreateCallback.method(:call)
    end

    register :user_update_callback do
      Curate::Service::UserUpdateCallback.method(:call)
    end

    # An anonymous function that receives a path to a file
    # and returns AntiVirusScanner::NO_VIRUS_FOUND_RETURN_VALUE if no
    # virus is found; Any other returned value means a virus was found
    attr_writer :default_antivirus_instance
    def default_antivirus_instance
      @default_antivirus_instance ||= lambda {|file_path|
        AntiVirusScanner::NO_VIRUS_FOUND_RETURN_VALUE
      }
    end


    # When was this last built/deployed
    attr_writer :build_identifier
    def build_identifier
      # If you restart the server, this could be out of sync; A better
      # implementation is to read something from the file system. However
      # that detail is an exercise for the developer.
      @build_identifier ||= Time.now.strftime("%Y-%m-%d %H:%M:%S")
    end

    # Override characterization runner
    attr_accessor :characterization_runner

    def register_curation_concern(*curation_concern_types)
      Array(curation_concern_types).flatten.compact.each do |cc_type|
        class_name = cc_type.to_s.classify
        if ! registered_curation_concern_types.include?(class_name)
          self.registered_curation_concern_types << class_name
        end
      end
    end

    def registered_curation_concern_types
      @registered_curation_concern_types ||= []
    end
  end

  configure {}
end
