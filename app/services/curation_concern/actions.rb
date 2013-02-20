# Actions are decoupled from controller logic so that they may be called from a controller or a background job.
module CurationConcern::Actions

  def self.create_metadata(curation_concern, user, attributes)
    curation_concern.apply_depositor_metadata(user.user_key)
    curation_concern.creator = user.name
    curation_concern.attributes = attributes
    #TODO setting permission in UI and passing the params to repo
    #curation_concern.set_visibility(params[:visibility])
    curation_concern.save!
    yield(curation_concern) if block_given?
    return curation_concern
  end

  def self.update_metadata(curation_concern, user, attributes)
    curation_concern.apply_depositor_metadata(user.user_key)
    curation_concern.creator = user.name
    curation_concern.update_attributes(attributes)
    curation_concern.save!
    yield(curation_concern) if block_given?
    return curation_concern
  end
end