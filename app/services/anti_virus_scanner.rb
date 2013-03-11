class AntiVirusScanner
  attr_reader :object, :file_path
  def initialize(object_with_pid, file_path)
    @object = object_with_pid
    @file_path = file_path
  end

  def call
    scanner_function.call(file_path) == 0
  end

  include Morphine
  register :scanner_function do
    Rails.configuration.default_antivirus_instance
  end
end