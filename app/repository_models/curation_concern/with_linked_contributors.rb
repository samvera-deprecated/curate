module CurationConcern::WithLinkedContributors
  extend ActiveSupport::Concern

  included do
    self.reflections[:contributors] = InlineReflection.new(allow_destroy: true)
    accepts_nested_attributes_for :contributors, allow_destroy: true, reject_if: :all_blank
    class_attribute :indefinite_article
    self.indefinite_article = 'a'
    class_attribute :contributor_label
    self.contributor_label = 'Contributor'
  end

  def contributors
    @contributors_association ||= ContributorsAssociation.new(self.descMetadata, self.class.reflections[:contributors])
  end

  def contributors= people
    self.contributors << people
  end

  def assign_nested_attributes_for_collection_association(association_name, attributes_collection)
    options = nested_attributes_options[association_name]
    
    
    if attributes_collection.is_a? Hash
      keys = attributes_collection.keys
      attributes_collection = if keys.include?('id') || keys.include?(:id)
        Array.wrap(attributes_collection)
      else
        attributes_collection.sort_by { |i, _| i.to_i }.map { |_, attributes| attributes }
      end
    end

    association = send(association_name)

    existing_records = if association.loaded?
      association.to_a
    else
      attribute_ids = attributes_collection.map {|a| a['id'] || a[:id] }.compact
      attribute_ids.present? ? association.to_a.select{ |x| attribute_ids.include?(x.pid)} : []
    end

    attributes_collection.each do |attributes|
      attributes = attributes.with_indifferent_access
      if attributes['id'].blank?
        #just passing in a name, so make a new person and associate it with this.
        association.build(attributes.except(*ActiveFedora::NestedAttributes::UNASSIGNABLE_KEYS)) unless call_reject_if(association_name, attributes)
      elsif existing_record = existing_records.detect { |record| record.id.to_s == attributes['id'].to_s }
        # It's an existing record, see if we mean to remove it?
        if !call_reject_if(association_name, attributes)
          association.delete(existing_record) if options[:allow_destroy] && has_destroy_flag?(attributes)
        end
      else
        # add a new one with this id
        association << ActiveFedora::Base.find(attributes['id'], cast: true) unless call_reject_if(association_name, attributes)
      end
    end
  end

  def to_solr(solr_doc = {})
    super
    # This field is a bit misleading, but the reference is stored in descMetadata
    solr_doc['desc_metadata__contributor_tesim'] = self.contributors.map(&:name)
    solr_doc
  end

  module ClassMethods
    def label_with_indefinite_article
      "#{indefinite_article} #{contributor_label.downcase}"
    end
  end
end
