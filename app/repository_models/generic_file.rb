require Sufia::Engine.root.join('app/models/generic_file')
class GenericFile
  belongs_to :batch, property: :is_part_of, class_name: 'ActiveFedora::Base'
  def to_s
    label
  end
end