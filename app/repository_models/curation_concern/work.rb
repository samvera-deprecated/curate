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

    included do
      before_destroy :clear_associations
    end

    def to_solr(solr_doc={}, opts={})
      super(solr_doc, opts)
      Solrizer.set_field(solr_doc, 'generic_type', 'Work', :facetable)
      return solr_doc
    end

    def add_editor_group(group)
      return unless group.is_a?(Hydramata::Group)
      self.editor_groups << group
      self.permissions_attributes = [{name: group.pid, access: "edit", type: "group"}]
      self.save!
      group.works << self
      group.save!
    end

    def remove_editor_group(group)
      return unless self.edit_groups.include?(group.pid)
      self.editor_groups.delete(group)
      self.edit_groups = self.edit_groups - [group.pid] 
      self.save!
      group.works.delete(self)
      group.save!
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
        remove_candidate_editor(editor)
      end
    end

    private

    def clear_associations
      clear_editor_groups
      clear_editors
    end

    def clear_editor_groups
      self.editor_groups.each do |editor_group|
        remove_editor_group(editor_group)
      end
    end

    def clear_editors
      self.editors.each do |editor|
        remove_candidate_editor(editor)
      end
    end

    def remove_candidate_editor(editor)
      self.editors.delete(editor)
      self.edit_users = self.edit_users - [editor.depositor]
      self.save!
      editor.works.delete(self)
      editor.save!
    end
  end
end
