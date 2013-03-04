class AntiVirusScanWorker
  class AntiVirusScanFailure < RuntimeError
    def initialize(pid, path, response_value)
      super("Anti Virus scan failed for PID=#{pid.inspect} at PATH=#{path.inspect} with RESPONSE=#{response_value.inspect}")
    end
  end
  def queue_name
    :anti_virus
  end

  attr_reader :pid, :file_path
  def initialize(pid, file_path)
    @pid = pid
    @file_path = file_path
  end

  # You don't really want to run CLAM everytime...in tests
  include Morphine
  register :anti_virus_instance do
    ClamAV.instance.method(:scanfile)
  end
  register :file_attacher do
    CurationConcern.method(:attach_file)
  end

  def run
    response_value = anti_virus_instance.call(file_path)
    response_value == 0 ? anti_virus_passed! : anti_virus_failed!(response_value)
  end

  protected

  def anti_virus_failed!(response_value)
    raise AntiVirusScanFailure.new(pid, file_path, response_value)
  end

  def anti_virus_passed!
    file_attacher.call(pid, file_path)
  end

end