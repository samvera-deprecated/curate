def FactoryGirl.create_generic_file(container_factory_name_or_object, user, file = nil)
  curation_concern =
  if container_factory_name_or_object.is_a?(Symbol)
    FactoryGirl.create_curation_concern(container_factory_name_or_object, user)
  else
    container_factory_name_or_object
  end

  generic_file = GenericFile.new
  file ||= Rack::Test::UploadedFile.new(__FILE__, 'text/plain', false)
  generic_file.file = file

  generic_file.apply_depositor_metadata(user.user_key)
  generic_file.creator = user.name
  generic_file.date_uploaded = Date.today
  generic_file.date_modified = Date.today
  generic_file.batch = curation_concern
  generic_file.set_visibility('psu')
  generic_file.save!


  Sufia::GenericFile::Actions.create_content(
    generic_file,
    file,
    file.original_filename,
    'content',
    user
  )

  return generic_file
end
