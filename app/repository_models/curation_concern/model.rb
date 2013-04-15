module CurationConcern
  module Model
    extend ActiveSupport::Concern

    included do
      include Hydra::ModelMixins::CommonMetadata
      include Sufia::ModelMethods
      include Sufia::Noid
      include Sufia::GenericFile::Permissions

      has_metadata name: "properties", type: PropertiesDatastream, control_group: 'M'
      delegate_to :properties, [:relative_path, :depositor], unique: true
      delegate_to :descMetadata, [:archived_object_type], unique: true
      before_save :set_archived_object_type
    end

    def human_readable_type
      self.class.to_s.demodulize.titleize
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
