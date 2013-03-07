def FactoryGirl.create_curation_concern(factory_name, user, override_attributes = {})
  pid = CurationConcern.mint_a_pid
  curation_concern = factory_name.to_s.classify.constantize.new(pid: pid)
  attributes = override_attributes.reverse_merge(FactoryGirl.attributes_for(factory_name))
  actor = CurationConcern.actor(curation_concern, user, attributes)
  actor.create!
  curation_concern
end