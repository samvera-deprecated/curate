class MintPurl
  def create_or_retreive_purl(obj_id)
    repo_object = RepoObject.where(:filename => obj_id).first
    if repo_object
      purl_id = Purl.where(:repo_object_id => repo_object.repo_object_id)
      return purl_url(purl_id, obj_id)
    end

    fed_obj = retreive_fedora_object(obj_id)
    Purl.transaction do
      @repo_object = RepoObject.create_from_fedora_object(fed_obj)
      @purl = Purl.create_from_repo_object(@repo_object)
    end
    return purl_url(@purl.purl_id, obj_id) if @repo_object

    nil
  end

  private

  # Two-step process to obtain the actual content-model type.
  def retreive_fedora_object(obj_id)
    ActiveFedora::Base.find(obj_id, cast: true)
  end

  def purl_url(purl_id, obj_id)
    File.join(PurlConfig.url, purl_id.to_s, obj_id)
  end

end
