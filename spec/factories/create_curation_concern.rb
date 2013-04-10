def FactoryGirl.create_curation_concern(factory_name, user, override_attributes = {})
  object = FactoryGirl.build(factory_name, override_attributes)

  object.apply_depositor_metadata(user.user_key)
  object.creator = user.to_s
  object.date_uploaded = Date.today
  object.date_modified = Date.today
  object.set_visibility(override_attributes[:visibility] || AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED)
  object.save!
  object
end