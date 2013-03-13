require Sufia::Engine.root.join('app/models/generic_file')
class GenericFile
  belongs_to :batch, property: :is_part_of, class_name: 'ActiveFedora::Base'

  validates :batch, presence: true

  attr_accessor :file, :version, :visibility

  def filename
    content.label
  end

  def to_s
    title || label || "No Title"
  end

  def versions
    content.versions
  end

  def current_version_id
    content.latest_version.versionID
  end
end
