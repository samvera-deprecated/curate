module CurationConcern
  class SeniorThesisActor < CurationConcern::BaseActor

    def create!
      super
      create_files
      assign_doi_if_applicable
    end

    def update!
      super
      update_contained_generic_file_visibility
      assign_doi_if_applicable
    end

    protected
    def files
      return @files if defined?(@files)
      @files = [attributes[:files]].flatten.compact
    end

    def create_files
      files.each do |file|
        generic_file = GenericFile.new
        generic_file.file = file
        generic_file.batch = curation_concern
        Sufia::GenericFile::Actions.create_metadata(
          generic_file, user, curation_concern.pid
        )
        generic_file.set_visibility(visibility)
        CurationConcern.attach_file(generic_file, user, file)
      end
    end

    def update_contained_generic_file_visibility
      if visibility_may_have_changed?
        curation_concern.generic_files.each do |f|
          f.set_visibility(visibility)
          f.save!
        end
      end
    end

    def assign_doi_if_applicable
      if attributes[:assign_doi].to_i != 0
        doi_minter.call(curation_concern.pid)
      end
    end

    include Morphine
    register :doi_minter do
      lambda { |pid|
        Sufia.queue.push(DoiWorker.new(pid))
      }
    end
  end
end
