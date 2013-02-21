# Actions are decoupled from controller logic so that they may be called from a controller or a background job.

module CurationConcern
  module Actions

    def self.create_metadata(curation_concern, user, attributes)
      file = attributes.delete(:thesis_file)
      visibility = attributes.delete(:visibility)
      curation_concern.apply_depositor_metadata(user.user_key)
      curation_concern.creator = user.name
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
    end

    def self.update_metadata(curation_concern, user, attributes)
      curation_concern.apply_depositor_metadata(user.user_key)
      curation_concern.creator = user.name
      curation_concern.update_attributes(attributes)
      curation_concern.save!
    end
  end
end
