module CurationConcern
  class SeniorThesisActor < CurationConcern::BaseActor

    def create!
      super
      create_thesis_file
      assign_doi_if_applicable
    end

    def update!
      super
      update_contained_generic_file_visibility
      assign_doi_if_applicable
    end

    protected
    def thesis_file
      return @thesis_file if defined?(@thesis_file)
      @thesis_file = attributes.delete(:thesis_file)
    end

    def create_thesis_file
      if thesis_file
        generic_file = GenericFile.new
        generic_file.file = thesis_file
        generic_file.batch = curation_concern
        generic_file.label = 'Senior Thesis'
        Sufia::GenericFile::Actions.create_metadata(
          generic_file, user, curation_concern.pid
        )
        generic_file.set_visibility(visibility)
        CurationConcern.attach_file(generic_file, user, thesis_file)
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
