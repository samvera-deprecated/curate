require Sufia::Engine.root.join('app/models/generic_file')
class GenericFile
  belongs_to :batch, property: :is_part_of, class_name: 'ActiveFedora::Base'

  attr_accessor :revised_file, :version
  def to_s
    label
  end

  def display_title
    title =  self.title.blank? ? label : self.title
    title = 'No Title' if title.blank?
    title
  end

  def versions
    content.versions
  end

  def current_version_id
    content.latest_version.versionID
  end
end