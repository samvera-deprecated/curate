require File.expand_path("../../../lib/sufia/generic_file/thumbnail", __FILE__)
require Sufia::Models::Engine.root.join('app/models/generic_file')
require File.expand_path("../curation_concern/with_access_right", __FILE__)
require File.expand_path("../curation_concern/embargoable", __FILE__)
require File.expand_path("../../repository_datastreams/file_content_datastream", __FILE__)

class GenericFile
  include CurationConcern::WithAccessRight
  include CurationConcern::Embargoable
  include Curate::ActiveModelAdaptor

  belongs_to :batch, property: :is_part_of, class_name: 'ActiveFedora::Base'

  validates :batch, presence: true
  validates :file, presence: true, on: :create

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
