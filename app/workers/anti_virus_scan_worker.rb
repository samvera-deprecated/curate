class AntiVirusScanWorker
  class AntiVirusScanFailure < RuntimeError
    def initialize(pid, path)
      super("Anti Virus scan failed for PID=#{pid.inspect} at PATH=#{path.inspect}")
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

  def run
    response_value = anti_virus_instance.call(file_path)
    if response_value == 0
      # Spawn a characterization
    else
      raise AntiVirusScanFailure.new(pid, file_path)
      # Failure, sad panda
    end
  end

  include Morphine
  register :anti_virus_instance do
    ClamAV.instance.method(:scanfile)
  end
end