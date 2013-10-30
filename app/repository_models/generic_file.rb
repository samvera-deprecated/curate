require File.expand_path("../curation_concern/embargoable", __FILE__)
require File.expand_path("../../repository_datastreams/file_content_datastream", __FILE__)

class GenericFile < ActiveFedora::Base
  include Sufia::ModelMethods
  include Hydra::AccessControls::Permissions
  include CurationConcern::Embargoable # overrides visibility, so must come after Permissions
  include Sufia::GenericFile::Characterization
  include Curate::ActiveModelAdaptor
  include Sufia::GenericFile::Versions
  include Sufia::GenericFile::Audit
  include Sufia::GenericFile::MimeTypes
  include Sufia::GenericFile::Thumbnail
  include Sufia::GenericFile::Derivatives

  include CurationConcern::RemotelyIdentifiedByDoi::Attributes

  belongs_to :batch, property: :is_part_of, class_name: 'ActiveFedora::Base'

  validates :batch, presence: true
  validates :file, presence: true, on: :create

  has_metadata "descMetadata", type: GenericFileRdfDatastream
  has_metadata 'properties', type: Curate::PropertiesDatastream
  has_file_datastream "content", type: FileContentDatastream
  has_file_datastream "thumbnail"
  
  has_attributes :owner, :depositor, datastream: :properties, multiple: false
  has_attributes :date_uploaded, :date_modified, datastream: :descMetadata, multiple: false 
  has_attributes :creator, :title, datastream: :descMetadata, multiple: true

  class_attribute :human_readable_short_description
  self.human_readable_short_description = "An arbitrary single file."

  attr_accessor :file, :version

  def filename
    content.label
  end

  def to_s
    return title.join(", ") if title.present?
    label || "No Title"
  end

  def versions
    content.versions
  end

  def current_version_id
    content.latest_version.versionID
  end

  def human_readable_type
    self.class.to_s.demodulize.titleize
  end
end
