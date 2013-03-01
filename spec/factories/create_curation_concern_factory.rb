def FactoryGirl.create_curation_concern(factory_name, user, attributes = nil)
  pid = CurationConcern.mint_a_pid
  curation_concern = factory_name.to_s.classify.constantize.new(pid: pid)
  attributes ||= FactoryGirl.attributes_for(factory_name)
  actor = CurationConcern.actor(curation_concern, user, attributes)
  actor.create!
  curation_concern
end