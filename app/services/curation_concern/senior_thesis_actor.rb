module CurationConcern
  class SeniorThesisActor < CurationConcern::BaseActor
    def save
      super
      save_thesis_file
      update_contained_generic_file_visibility
    end

    protected
    def thesis_file
      return @thesis_file if defined?(@thesis_file)
      @thesis_file = attributes.delete(:thesis_file)
    end

    def save_thesis_file
      if thesis_file
        generic_file = GenericFile.new
        Sufia::GenericFile::Actions.create_metadata(
          generic_file, user, curation_concern.pid
        )
        Sufia::GenericFile::Actions.create_content(
          generic_file,
          thesis_file,
          thesis_file.original_filename,
          'content',
          user
        )
      end
    end

    def update_contained_generic_file_visibility
      if visibility_may_have_changed?
        curation_concern.generic_files.each do |f|
          f.set_visibility(visibility)
        end
      end
    end

  end
end
