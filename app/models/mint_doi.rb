class MintDoi
  def create(fed_obj)
    digital_object_identifier = DigitalObjectIdentifier.new
    digital_object_identifier.target = fed_obj.target
    digital_object_identifier.title = fed_obj.title
    digital_object_identifier.creator = fed_obj.creator
    digital_object_identifier.publisher = fed_obj.publisher
    digital_object_identifier.publicationyear = fed_obj.publicationyear
    return digital_object_identifier.doi
  end

  # Two-step process to obtain the actual content-model type.
  def retreive_fedora_object(obj_id)
    fed_obj = ActiveFedora::Base.new(obj_id)
    cmodel_arr = ActiveFedora::ContentModel.known_models_for(fed_obj)
    cmodel = cmodel_arr.first
    return cmodel.find(obj_id)
  end

  # Return DOI if already stored in fedora object. If not create a new DOI and store it in the fedora object.
  def create_or_retreive_doi(obj_id)
    fed_obj = retreive_fedora_object(obj_id)
    if doi = fed_obj.doi
      return doi
    end
    if((!fed_obj.target.nil?) && (!fed_obj.title.nil?) && (!fed_obj.creator.nil?) && (!fed_obj.publisher.nil?) && (!fed_obj.publicationyear.nil?))
      fed_obj.doi= create(fed_obj)
      fed_obj.save
      return fedora_obj.doi
    end
    return
  end
end
