class MintPurl
  def create(obj_id)
    fed_obj = retreive_fedora_object(obj_id)
    purl_id = RepoObject.where(:filename => fed_obj.pid)
    if purl_id
      return purl_id
    end
    repo_object = RepoObject.new
    repo_object.create_repo_object(fed_obj)
    purl = Purl.new
    purl.create_purl(repo_object)
    object_access = ObjectAccess.new
    object_access.create_object_access(purl)
    return repo_object.repo_object_id
  end

  # Retreive Fedora Object for the give obj_id (PID). 
  def retreive_fedora_object(obj_id)
    fed_obj = ActiveFedora::Base.new(obj_id)
    cmodel_arr = ActiveFedora::ContentModel.known_models_for(fed_obj)
    cmodel = cmodel_arr.first
    return cmodel.find(obj_id)
  end
end
