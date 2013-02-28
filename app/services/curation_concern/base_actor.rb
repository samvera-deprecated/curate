module CurationConcern
  # The CurationConcern base actor should respond to three primary actions:
  # * #create
  # * #update
  # * #delete
  class BaseActor
    attr_reader :curation_concern, :user, :attributes
    def initialize(curation_concern, user, attributes)
      @curation_concern = curation_concern
      @user = user
      @attributes = attributes
    end

    def create
      save_metadata do
        curation_concern.apply_depositor_metadata(user.user_key)
        curation_concern.creator = user.name
        curation_concern.date_uploaded = Date.today
      end
    end
    alias_method :create_metadata, :create

    def update
      save_metadata
    end
    alias_method :update_metadata, :update

    def save_metadata
      file = attributes.delete(:thesis_file)
      visibility = attributes.delete(:visibility)

      yield if block_given?

      curation_concern.attributes = attributes
      curation_concern.date_modified = Date.today
      curation_concern.set_visibility(visibility)
      curation_concern.save!

      if file
        generic_file = GenericFile.new
        Sufia::GenericFile::Actions.create_metadata(generic_file, user, curation_concern.pid)
        Sufia::GenericFile::Actions.create_content(
          generic_file,
          file,
          file.original_filename,
          'content',
          user
        )
      end
      if curation_concern.respond_to?(:generic_file)
        curation_concern.generic_files.each do |f|
          f.set_visibility(visibility)
        end
      end
    end
    protected :save_metadata

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
      if !version_to_revert.blank? and version_to_revert !=  curation_concern.content.latest_version.versionID
        revision = curation_concern.content.get_version(version_to_revert)
        mime_type = revision.mimeType.empty? ? "application/octet-stream" : revision.mimeType
        options = {:label=>revision.label, :mimeType=>mime_type, :dsid=>'content'}
        curation_concern.add_file_datastream(revision.content, options)
        curation_concern.record_version_committer(user)
        curation_concern.save!
      end
    end

  end
end
