require Sufia::Engine.root.join('app/models/generic_file')
class GenericFile
  belongs_to :batch, property: :is_part_of, class_name: 'ActiveFedora::Base'

  validates :batch, presence: true

  attr_accessor :revised_file, :version

  # Either :revised_file or :file should be the canonical accessor
  # but for now we have both.
  alias_attribute :file, :revised_file

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