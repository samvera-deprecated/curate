module CurationConcern
  class GenericFileActor < CurationConcern::BaseActor
    def update
      super
      update_file
      update_version
    end
    protected
    def update_file
      file = attributes.delete(:revised_file)
      title= attributes.delete(:title) || file.original_filename
      if file
        Sufia::GenericFile::Actions.create_content(
          curation_concern,
          file,
          title,
          'content',
          user
        )
      end
    end

    def update_version
      version_to_revert = attributes.delete(:version)
      return true if version_to_revert.blank?
      return true if version_to_revert.to_s ==  curation_concern.current_version_id

      revision = curation_concern.content.get_version(version_to_revert)
      mime_type = revision.mimeType.empty? ? "application/octet-stream" : revision.mimeType
      options = { label: revision.label, mimeType: mime_type, dsid: 'content' }
      curation_concern.add_file_datastream(revision.content, options)
      curation_concern.record_version_committer(user)
      curation_concern.save!
    end
  end
end
