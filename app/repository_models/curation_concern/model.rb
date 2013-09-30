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
      include Sufia::GenericFile::Permissions
      include Curate::ActiveModelAdaptor
      include Hydra::Collections::Collectible
      
      extend ClassMethods

      has_metadata name: "properties", type: PropertiesDatastream, control_group: 'M'
      delegate_to :properties, [:relative_path, :depositor], unique: true
      delegate_to :descMetadata, [:resource_type], unique: true
      before_save :set_resource_type

      class_attribute :human_readable_short_description
    end

    def human_readable_type
      self.class.human_readable_type
    end

    def set_resource_type
      self.resource_type = human_readable_type
    end

    # Parses a comma-separated string of tokens, returning an array of ids
    def self.ids_from_tokens(tokens)
      tokens.gsub(/\s+/, "").split(',')
    end

    def as_json(options)
      { pid: pid, title: title, model: self.class.to_s, curation_concern_type: resource_type }
    end

    def to_solr(solr_doc={}, opts={})
      super(solr_doc, opts)
      index_collection_pids(solr_doc)
      solr_doc[Solrizer.solr_name('noid', Sufia::GenericFile.noid_indexer)] = noid
      Solrizer.set_field(solr_doc, 'generic_type', 'Work', :facetable)
      return solr_doc
    end

    def to_s
      title
    end

    # Returns a string identifying the path associated with the object. ActionPack uses this to find a suitable partial to represent the object.
    def to_partial_path 
      "curation_concern/#{super}"
    end

  end
end
