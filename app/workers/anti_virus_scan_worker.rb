class AntiVirusScanWorker
  def queue_name
    :anti_virus
  end

  def initialize(pid)
    @pid = pid
  end
end