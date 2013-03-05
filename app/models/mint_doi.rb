class MintDoi

  # Return DOI if already stored in fedora object. If not create a new DOI and store it in the fedora object.
  def create_or_retreive_doi(obj_id)
    fed_obj = retreive_fedora_object(obj_id)
    if !(doi = fed_obj.identifier).nil?
      return doi
    end
    if((!fed_obj.url.nil?) && (!fed_obj.title.nil?) && (!fed_obj.creator.nil?) && (!fed_obj.publisher.nil?) && (!fed_obj.publicationyear.nil?))
      fed_obj.identifier = create(fed_obj)
      fed_obj.save
      return fedora_obj.identifier
    end
    return
  end

  private

  def create(fed_obj)
    digital_object_identifier = DigitalObjectIdentifier.new
    digital_object_identifier.target = create_or_retreive_purl(fed_obj.pid)
    digital_object_identifier.title = fed_obj.title
    digital_object_identifier.creator = fed_obj.creator
    digital_object_identifier.publisher = "Hesburgh Library - University of Notre Dame"
    digital_object_identifier.publicationyear = Time.now.year
    return digital_object_identifier.doi
  end

  # Two-step process to obtain the actual content-model type.
  def retreive_fedora_object(obj_id)
    fed_obj = ActiveFedora::Base.find(obj_id)
    cmodel_arr = ActiveFedora::ContentModel.known_models_for(fed_obj)
    cmodel = cmodel_arr.first
    return cmodel.find(obj_id)
  end

  # Return purl link for the given fedora ID.
  def create_or_retreive_purl(obj_id)
    mint_purl = MintPurl.new
    mint_purl.create_or_retreive_purl(obj_id)
  end
end
