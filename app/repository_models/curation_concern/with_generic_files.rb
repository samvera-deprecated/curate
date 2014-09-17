module CurationConcern
  module WithGenericFiles
    extend ActiveSupport::Concern

    included do
      has_many :generic_files, property: :is_part_of
      before_destroy :before_destroy_cleanup_generic_files
    end

    def before_destroy_cleanup_generic_files
      generic_files.each(&:destroy)
    end

    def with_empty_contents?
      generic_files.any? {|gf| gf.with_empty_content?}
    end

  end
end


