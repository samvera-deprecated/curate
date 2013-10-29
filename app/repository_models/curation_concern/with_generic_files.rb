module CurationConcern
  module WithGenericFiles
    extend ActiveSupport::Concern

    included do
      has_many :generic_files, property: :is_part_of

      after_destroy :after_destroy_cleanup_generic_files
    end

    def after_destroy_cleanup_generic_files
      generic_files.each(&:destroy)
    end

    def representative_generic_file_object
      return nil if self.representative.nil?
      @representative_generic_file_object ||= GenericFile.find(self.representative)
    end

  end
end
