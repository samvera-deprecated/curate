class LinkedResource < ActiveFedora::Base
  include Curate::ActiveModelAdaptor
  include Sufia::ModelMethods

  has_file_datastream "content", control_group: 'E'
  belongs_to :batch, property: :is_part_of, class_name: 'ActiveFedora::Base'
  has_metadata "descMetadata", type: GenericFileRdfDatastream

  delegate_to :descMetadata, [ :date_uploaded, :date_modified, :creator], unique: true

  validates :batch, presence: true

  class_attribute :human_readable_short_description
  self.human_readable_short_description = "An arbitrary single file."

  def url= url
    content.dsLocation = url
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

