module CurationConcern
  module Work
    extend ActiveSupport::Concern

    # Parses a comma-separated string of tokens, returning an array of ids
    def self.ids_from_tokens(tokens)
      tokens.gsub(/\s+/, "").split(',')
    end

    unless included_modules.include?(CurationConcern::Model)
      include CurationConcern::Model
    end
    include Hydra::AccessControls::Permissions

    def to_solr(solr_doc={}, opts={})
      super(solr_doc, opts)
      Solrizer.set_field(solr_doc, 'generic_type', 'Work', :facetable)
      return solr_doc
    end
  end
end
