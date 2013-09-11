require 'active_fedora/registered_attributes'

# Person - A named singular entity; A Person may have a one to one relationship with a User. A Person is a Container.
#   profile: Each person has a profile which is actually just a collection that is explicitly referenced by the person using a :has_profile relationship.
class Person < ActiveFedora::Base
  include ActiveFedora::RegisteredAttributes
  include CurationConcern::Model

  has_metadata name: "descMetadata", type: PersonMetadataDatastream, control_group: 'M'

  belongs_to :profile, property: :has_profile, class_name: 'Collection'

  attribute :name,
      datastream: :descMetadata, multiple: false

  attribute :preferred_email,
      datastream: :descMetadata, multiple: false

  attribute :alternate_email,
      datastream: :descMetadata, multiple: false

  attribute :date_of_birth,
      datastream: :descMetadata, multiple: false

  attribute :title,
      datastream: :descMetadata, multiple: false

  attribute :campus_phone_number,
      datastream: :descMetadata, multiple: false

  attribute :alternate_phone_number,
      datastream: :descMetadata, multiple: false

  attribute :personal_webpage,
      datastream: :descMetadata, multiple: false

  attribute :blog,
      datastream: :descMetadata, multiple: false

  attribute :gender,
      datastream: :descMetadata, multiple: false

  def date_uploaded
    Time.new(create_date).strftime("%Y-%m-%d")
  end

  def first_name
    name_parser.given
  end

  def last_name
    name_parser.family
  end

  def name_parser
    Namae.parse(self.name).first
  end

  # Create associated Profile (which is a Collection object)
  # Note: marks the profile with resource_type "Profile" (default is Collection) so it can be displayed in Search Results and Facets
  #   as a Profile instead of a Collection.
  def create_profile(depositor)
    collection = Collection.new(title: self.name, resource_type: "Profile")
    collection.apply_depositor_metadata(depositor.user_key)
    collection.read_groups = [Sufia::Models::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC]
    collection.save!
    self.profile = collection
    self.save!
    self.profile
  end

end
