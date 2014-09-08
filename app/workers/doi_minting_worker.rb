# The purpose of this class is to mint doi.
# This is an assynchronous process.

class DoiMintingWorker
  class PidError < RuntimeError
    def initialize(url_string)
      super(url_string)
    end
  end

  def queue_name
    :doi_miniting_requests
  end

  attr_accessor :pid

  def initialize(pid)
    self.pid = pid
  end

  def run
    if pid.blank?
      raise PidError.new("PID required for DOI creation.")
    end
    doi_request_object = ActiveFedora::Base.find( pid, cast: true )
    doi_remote_service.mint(doi_request_object)
  end

  def doi_remote_service
    @doi_remote_service ||= Hydra::RemoteIdentifier.remote_service(:doi)
  end
end
