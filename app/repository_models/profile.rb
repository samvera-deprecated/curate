class Profile < ActiveFedora::Base
  include CurationConcern::CollectionModel

  has_many :associated_persons, property: :has_profile, class_name: 'Person'

  has_attributes :resource_type, datastream: :descMetadata, multiple: false


  # Causes resource_type to be set in the metadata
  before_create :human_readable_type

  # Reads from resource_type attribute.
  # Defaults to "Collection", but can be set to something else.
  # Profiles are marked with resource_type of "Profile" when they're created by the associated Person object
  # This is used to populate the Object Type Facet
  def human_readable_type
    self.resource_type ||= "Profile"
  end

end
