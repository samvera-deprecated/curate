module CurationConcern::WithLinkedContributors
  extend ActiveSupport::Concern

  included do
    class_attribute :indefinite_article
    self.indefinite_article = 'a'
    class_attribute :contributor_label
    self.contributor_label = 'Contributor'
  end

  def to_solr(solr_doc = {})
    super
    # This field is a bit misleading, but the reference is stored in descMetadata
    solr_doc['desc_metadata__contributor_tesim'] = self.contributor
    solr_doc
  end

  module ClassMethods
    def label_with_indefinite_article
      "#{indefinite_article} #{contributor_label.downcase}"
    end
  end
end
