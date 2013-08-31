require 'active_fedora/registered_attributes'

class Person < ActiveFedora::Base
  include ActiveFedora::RegisteredAttributes

  has_metadata name: "descMetadata", type: PersonMetadataDatastream, control_group: 'M'

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

  def self.find_or_create_by_user(user)
    return Person.find(user.repository_id.to_s)
  rescue ActiveFedora::ObjectNotFoundError, ArgumentError
    return create_person(user)
  end

  def self.create_person(user)
    person = Person.new
    person.name = user.get_value_from_ldap(:display_name)
    person.preferred_email = user.get_value_from_ldap(:preferred_email)
    person.alternate_email = user.email
    person.save!
    person.update_user!(user)
    person
  end

  def update_user!(user)
    user.update_column(:repository_id, self.pid)
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
end
