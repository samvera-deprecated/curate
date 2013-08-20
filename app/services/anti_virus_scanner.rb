require 'morphine'

# This is a simple wrapper for an underlying scanner; Without it, we'll
# always going to be running actual anti-virus
class AntiVirusScanner
  NO_VIRUS_FOUND_RETURN_VALUE = 0 unless defined?(NO_VIRUS_FOUND_RETURN_VALUE)

  class VirusDetected < RuntimeError
    def initialize(pid, file_path)
      super("A virus was found for PID=#{pid.inspect} (#{file_path.inspect})")
    end
  end
  attr_reader :object
  def initialize(object_with_pid)
    @object = object_with_pid
  end

  def call(file_path)
    if scanner_instance.call(file_path) == NO_VIRUS_FOUND_RETURN_VALUE
      return true
    else
      raise VirusDetected.new(object.pid, file_path)
    end
  end

  include Morphine
  register :scanner_instance do
    Curate.configuration.default_antivirus_instance
  end
end