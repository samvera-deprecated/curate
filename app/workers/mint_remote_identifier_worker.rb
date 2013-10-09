class MintRemoteIdentifierWorker
  def self.enqueue(pid, remote_service_name)
    Sufia.queue.push(new(pid, remote_service_name))
  end

  def queue_name
    :remote_identifiers
  end

  attr_reader :pid, :remote_service_name
  def initialize(pid, remote_service_name)
    @pid = pid
    @remote_service_name = remote_service_name
  end

  def run
    Hydra::RemoteIdentifier.mint(remote_service_name, target)
  end

  private
  def target
    @target ||= ActiveFedora::Base.find(pid)
  end

end
