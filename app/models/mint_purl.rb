class MintPurl

  class PurlError < RuntimeError
    def initialize(error_message)
      super(error_message)
    end
  end

  def create_or_retreive_purl(fed_obj)
    repo_object = RepoObject.where(:filename => fed_obj.pid).first
    if repo_object
      purl = Purl.where(:repo_object_id => repo_object.repo_object_id).first
      return purl_url(purl.purl_id, fed_obj)
    end

    Purl.transaction do
      @repo_object = RepoObject.create_from_fedora_object(fed_obj)
      @purl = Purl.create_from_repo_object(@repo_object)
    end
    return purl_url(@purl.purl_id, fed_obj) if @purl
  rescue => e
    raise PurlError.new("Could not create Purl for the following reasons: #{e.backtrace.inspect}")
  end

  private

  def purl_url(purl_id, fed_obj)
    File.join(PurlConfig.url, purl_id.to_s, fed_obj.pid)
  end

end
