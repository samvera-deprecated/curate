class LinkedResource < ActiveFedora::Base
  include Hydra::AccessControls::Permissions
  include Curate::ActiveModelAdaptor
  include Sufia::ModelMethods

  has_file_datastream "content", control_group: 'E'
  belongs_to :batch, property: :is_part_of, class_name: 'ActiveFedora::Base'
  has_metadata "descMetadata", type: GenericFileRdfDatastream

  has_attributes :date_uploaded, :date_modified, :creator, datastream: :descMetadata, multiple: false

  has_metadata 'properties', type: Curate::PropertiesDatastream
  has_attributes :relative_path, :depositor, :owner, datastream: :properties, multiple: false

  validates :batch, presence: true
  validates :url, presence: true

  class_attribute :human_readable_short_description
  self.human_readable_short_description = "An arbitrary single file."
  include ActionView::Helpers::SanitizeHelper

  def url= url
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

  def human_readable_type
    self.class.to_s.demodulize.titleize
  end

end

