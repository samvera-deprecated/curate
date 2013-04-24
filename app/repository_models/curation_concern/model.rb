module CurationConcern
  module Model
    extend ActiveSupport::Concern

    module ClassMethods
      def human_readable_type
        name.demodulize.titleize
      end
    end

    included do
      include Hydra::ModelMixins::CommonMetadata
      include Sufia::ModelMethods
      include Sufia::Noid
      include Sufia::GenericFile::Permissions
      extend ClassMethods

      has_metadata name: "properties", type: PropertiesDatastream, control_group: 'M'
      delegate_to :properties, [:relative_path, :depositor], unique: true
      delegate_to :descMetadata, [:archived_object_type], unique: true
      before_save :set_archived_object_type

      class_attribute :human_readable_short_description
    end

    def human_readable_type
      self.class.human_readable_type
    end

    def set_archived_object_type
      self.archived_object_type = human_readable_type
    end

    def to_solr(solr_doc={}, opts={})
      super(solr_doc, opts)
      solr_doc["noid_s"] = noid
      return solr_doc
    end

    def to_param
      noid
    end

    def to_s
      title
    end

  end
end
