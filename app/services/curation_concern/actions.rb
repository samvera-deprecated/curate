# Actions are decoupled from controller logic so that they may be called from a controller or a background job.
module CurationConcern
  def self.mint_a_pid
    Sufia::Noid.namespaceize(Sufia::Noid.noidify(Sufia::IdService.mint))
  end
  module Actions

    def self.create_metadata(curation_concern, user, attributes)
      file = attributes.delete(:thesis_file)
      curation_concern.apply_depositor_metadata(user.user_key)
      curation_concern.creator = user.name
      curation_concern.attributes = attributes
      curation_concern.save!

      if file
        generic_file = GenericFile.new
        generic_file.batch = curation_concern
        Sufia::GenericFile::Actions.create_content(
          generic_file,
          file,
          file.original_filename,
          'content',
          current_user
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
