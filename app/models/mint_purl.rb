class MintPurl
  def create(obj_id)
    fed_obj = retreive_fedora_object(obj_id)
    repo_object = RepoObject.where(:filename => fed_obj.pid).first
    return repo_object.repo_object_id if repo_object
    Purl.transaction do
      repo_object = RepoObject.create_from_fedora_object(fed_obj)
      purl = Purl.create_from_repo_object(repo_object)
    end
    return repo_object.repo_object_id if repo_object
    nil
  end

  private
  # Retreive Fedora Object for the give obj_id (PID). 
  def retreive_fedora_object(obj_id)
    return ActiveFedora::Base.new(obj_id, cast: true)
  end
end
