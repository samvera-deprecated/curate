class Collection < ActiveFedora::Base
  include Hydra::Collection
  include Sufia::GenericFile::Permissions
  include Sufia::Models::WithAccessRight

  has_many :associated_persons, property: :has_profile, class_name: 'Person'

  delegate_to :descMetadata, [:resource_type], :unique => true

  # Reads from resource_type attribute.
  # Defaults to "Collection", but can be set to something else.
  # Profiles are marked with resource_type of "Profile" when they're created by the associated Person object
  # This is used to populate the Object Type Facet
  def human_readable_type
    self.resource_type ||= "Collection"
  end

  def is_profile?
    !associated_persons.empty?
  end

  def to_s
    self.title.nil? ? self.inspect : self.title
  end

  def to_solr(solr_doc={}, opts={})
    super
    solr_doc[Solrizer.solr_name("desc_metadata__archived_object_type", :facetable)] = human_readable_type
    solr_doc
  end
end
