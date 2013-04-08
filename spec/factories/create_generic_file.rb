def FactoryGirl.create_generic_file(container_factory_name_or_object, user, file = nil)
  container = ActiveFedora::Base.new
  container.save!

  generic_file = GenericFile.new
  file ||= Rack::Test::UploadedFile.new(__FILE__, 'text/plain', false)
  generic_file.file = file

  generic_file.apply_depositor_metadata(user.user_key)
  generic_file.creator = user.name
  generic_file.date_uploaded = Date.today
  generic_file.date_modified = Date.today
  generic_file.batch = container
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
