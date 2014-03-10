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

    def add_editor(editor)
      return unless editor.is_a?(Person)
      self.editors << editor
      self.permissions_attributes = [{name: editor.depositor, access: "edit", type: "person"}] unless self.depositor == editor.depositor
      self.save!
      editor.works << self
      editor.save!
    end

    def remove_editor(editor)
      if( ( self.depositor != editor.depositor ) && ( self.editors.include?( editor ) ) )
        self.editors.delete(editor)
        self.edit_users = self.edit_users - [editor.depositor]
        self.save!
        editor.works.delete(self)
        editor.save!
      end
    end
  end
end
