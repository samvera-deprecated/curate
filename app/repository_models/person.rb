require 'active_fedora/registered_attributes'

# Person - A named singular entity; A Person may have a one to one relationship with a User. A Person is a Container.
#   profile: Each person has a profile which is actually just a collection that is explicitly referenced by the person using a :has_profile relationship.
class Person < ActiveFedora::Base
  include ActiveFedora::RegisteredAttributes
  include CurationConcern::Work
  include Hydra::Derivatives

  has_and_belongs_to_many :groups, class_name: "::Hydramata::Group", property: :is_member_of, inverse_of: :has_member
  has_metadata name: "descMetadata", type: PersonMetadataDatastream, control_group: 'M'
  has_file_datastream :name => "content"
  has_file_datastream :name => "medium"
  has_file_datastream :name => "thumbnail"

  belongs_to :profile, property: :has_profile, class_name: 'Profile'

  attr_accessor :mime_type
  makes_derivatives :generate_derivatives

  attribute :name,
    datastream: :descMetadata, multiple: false

  attribute :email,
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

  def user
    persisted? ? User.where(repository_id: pid).first : nil
  end

  def to_solr(solr_doc={}, opts={})
    super(solr_doc, opts)
    Solrizer.set_field(solr_doc, 'generic_type', 'Person', :facetable)
    solr_doc['read_access_group_ssim'] = 'public'
    solr_doc['has_user_bsi'] = !!User.exists?(repository_id: pid)
    solr_doc[Solrizer.solr_name('representative', :stored_searchable)] = self.representative
    solr_doc[Solrizer.solr_name('representative_image_url', :stored_searchable)] = self.representative_image_url
    solr_doc
  end

  def representative
    to_param
  end

  def to_s
    name || "No Title"
  end

  GRAVATAR_URL = "//www.gravatar.com/avatar/"

  def add_profile_image(file)
    self.content.content = file
    self.mime_type = file.content_type
    generate_derivatives
  end

  def gravatar_link
    return @gravatar_link unless @gravatar_link.blank?
    @gravatar_link = File.join(GRAVATAR_URL, email_hash(self.email), "?s=300")
    @gravatar_link += "&d=" + File.join(GRAVATAR_URL, email_hash(self.alternate_email), "?s=300") unless self.alternate_email.blank?
    @gravatar_link
  end

  def representative_image_url
    self.thumbnail.content.present? ? generate_thumbnail_url : gravatar_link
  end

  def can_be_member_of_collection?(collection)
    false
  end

  private

  def generate_derivatives
    case mime_type
    when 'image/png', 'image/jpeg', 'image/tiff'
      transform_datastream :content, { medium: {size: "300x300>", datastream: 'medium'}, thumb: {size: "100x100>", datastream: 'thumbnail'} }
    end
  end

  def generate_thumbnail_url
    "/downloads/#{self.representative}?datastream_id=thumbnail"
  end

  def email_hash(gravatar_email)
    Digest::MD5.hexdigest(gravatar_email.to_s.strip.downcase)
  end

end
