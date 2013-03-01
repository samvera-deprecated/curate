def FactoryGirl.create_generic_file(container_factory_name_or_object, user, file = nil)
  curation_concern =
  if container_factory_name_or_object.is_a?(Symbol)
    FactoryGirl.create_curation_concern(container_factory_name_or_object, user)
  else
    container_factory_name_or_object
  end

  generic_file = GenericFile.new
  generic_file.batch = curation_concern
  file ||= Rack::Test::UploadedFile.new(__FILE__, 'text/plain', false)

  actor = CurationConcern::GenericFileActor.new(
    generic_file,
    user,
    {file: file}
  )
  actor.create!
  return generic_file
end
