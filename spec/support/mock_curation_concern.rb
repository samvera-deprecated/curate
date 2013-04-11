class MockCurationConcern < ActiveFedora::Base
  class MetadataDatastream < ActiveFedora::NtriplesRDFDatastream
  map_predicates do |map|
    map.title(in: RDF::DC) do |index|
      index.as :searchable, :displayable
    end
    map.created(in: RDF::DC)
    map.creator(in: RDF::DC) do |index|
      index.as :searchable, :facetable, :displayable
    end
    map.date_uploaded(to: "dateSubmitted", in: RDF::DC) do |index|
      index.type :date
      index.as :searchable, :displayable, :sortable
    end
    map.date_modified(to: "modified", in: RDF::DC) do |index|
      index.type :date
      index.as :searchable, :displayable, :sortable
    end
    map.part(:to => "hasPart", in: RDF::DC)
    map.identifier({in: RDF::DC})
  end
end
  include Hydra::ModelMixins::CommonMetadata
  include Sufia::ModelMethods
  include Sufia::Noid
  include Sufia::GenericFile::Permissions
  include CurationConcern::Embargoable
  include CurationConcern::WithAccessRight

  has_metadata name: "properties", type: PropertiesDatastream, control_group: 'M'
  delegate_to :properties, [:relative_path, :depositor], unique: true

  has_metadata name: "descMetadata", type: MockCurationConcern::MetadataDatastream, control_group: 'M'

  delegate_to(
    :descMetadata,
    [
      :title,
      :date_uploaded,
      :date_modified,
      :creator,
      :identifier,
    ],
    unique: true
  )

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

end