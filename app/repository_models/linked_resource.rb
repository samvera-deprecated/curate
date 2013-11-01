class LinkedResource < ActiveFedora::Base
  include Hydra::AccessControls::Permissions
  include Sufia::ModelMethods
  include CurationConcern::Model
  include ActiveFedora::RegisteredAttributes

  has_file_datastream "content", control_group: 'E'
  belongs_to :batch, property: :is_part_of, class_name: 'ActiveFedora::Base'
  has_metadata "descMetadata", type: GenericFileRdfDatastream

  attribute :title, multiple: false, datastream: :descMetadata
  has_attributes :date_uploaded, :date_modified, :creator, datastream: :descMetadata, multiple: false

  validates :batch, presence: true
  validates :url, presence: true

  self.human_readable_short_description = "An arbitrary single file."
  include ActionView::Helpers::SanitizeHelper

  def url=(url)
    u = URI::Parser.new.parse(url)
    return unless [URI::HTTP, URI::HTTPS, URI::FTP].include?(u.class)
    content.dsLocation = u.to_s
  end

  def url
    content.dsLocation
  end

  def to_s
    url
  end

  def to_solr(solr_doc={}, opts={})
    super
    Solrizer.set_field(solr_doc, 'url', url, :stored_searchable)
    solr_doc
  end


end

