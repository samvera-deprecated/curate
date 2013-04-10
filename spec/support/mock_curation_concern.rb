class MockCurationConcern < ActiveFedora::Base
  include Hydra::ModelMixins::CommonMetadata
  include Sufia::ModelMethods
  include Sufia::Noid
  include Sufia::GenericFile::Permissions
  include CurationConcern::Embargoable
  include CurationConcern::WithAccessRight

  has_metadata name: "properties", type: PropertiesDatastream, control_group: 'M'
  delegate_to :properties, [:relative_path, :depositor], unique: true

  has_many :generic_files, property: :is_part_of

  after_destroy :after_destroy_cleanup
  def after_destroy_cleanup
    generic_files.each(&:destroy)
  end

  def human_readable_type
    self.class.to_s.demodulize.titleize
  end
  def to_param
    pid.split(':').last
  end

  # This is metadata that should be used for the DOI
  def identifier
    to_param
  end
end
