module CurationConcern
  module Model
    extend ActiveSupport::Concern

    module ClassMethods
      def human_readable_type
        name.demodulize.titleize
      end
    end

    included do
      include Sufia::ModelMethods
      include Hydra::AccessControls::Permissions
      include Curate::ActiveModelAdaptor
      include Hydra::Collections::Collectible
      include Solrizer::Common
      
      has_metadata 'properties', type: Curate::PropertiesDatastream
      has_attributes:relative_path, :depositor, :owner, :representative, datastream: :properties, multiple: false
      class_attribute :human_readable_short_description
    end

    def human_readable_type
      self.class.human_readable_type
    end

    # Parses a comma-separated string of tokens, returning an array of ids
    def self.ids_from_tokens(tokens)
      tokens.gsub(/\s+/, "").split(',')
    end

    def as_json(options)
      { pid: pid, title: title, model: self.class.to_s, curation_concern_type: human_readable_type }
    end

    def to_solr(solr_doc={}, opts={})
      super(solr_doc, opts)
      index_collection_pids(solr_doc)
      solr_doc[Solrizer.solr_name('noid', Sufia::GenericFile.noid_indexer)] = noid
      solr_doc[Solrizer.solr_name('human_readable_type',:facetable)] = human_readable_type
      solr_doc[Solrizer.solr_name('human_readable_type', :stored_searchable)] = human_readable_type
      Solrizer.set_field(solr_doc, 'generic_type', 'Work', :facetable)
      add_derived_date_created(solr_doc)
      return solr_doc
    end

    def to_s
      title
    end

    # Returns a string identifying the path associated with the object. ActionPack uses this to find a suitable partial to represent the object.
    def to_partial_path 
      "curation_concern/#{super}"
    end

protected

    # A searchable date field that is derived from the (text) field date_created
    def add_derived_date_created(solr_doc)
      if self.respond_to?(:date_created)
        self.class.create_and_insert_terms('date_created_derived', derived_dates, [:dateable], solr_doc)
      end
    end

    def derived_dates
      dates = Array(date_created)
      dates.map { |date| Curate::DateFormatter.parse(date.to_s).to_s }
    end

  end
end
