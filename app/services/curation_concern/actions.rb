# Actions are decoupled from controller logic so that they may be called from a controller or a background job.

module CurationConcern
  module Actions
    module_function
    def create_metadata(curation_concern, user, attributes)
      save_metadata(curation_concern, user, attributes) do
        curation_concern.apply_depositor_metadata(user.user_key)
        curation_concern.creator = user.name
      end
    end

    def update_metadata(curation_concern, user, attributes)
      save_metadata(curation_concern, user, attributes)
    end

    def save_metadata(curation_concern, user, attributes)
      file = attributes.delete(:thesis_file)
      visibility = attributes.delete(:visibility)

      yield if block_given?

      curation_concern.attributes = attributes
      curation_concern.set_visibility(visibility)
      curation_concern.save!

      if file
        generic_file = GenericFile.new
        Sufia::GenericFile::Actions.create_metadata(generic_file, user, curation_concern.pid)
        generic_file.set_visibility(visibility)
        Sufia::GenericFile::Actions.create_content(
          generic_file,
          file,
          file.original_filename,
          'content',
          user
        )
      end
      curation_concern.generic_files.each do |generic_file|
          generic_file.set_visibility(visibility)
      end
    end
  end
end
