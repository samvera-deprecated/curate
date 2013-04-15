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
      map.archived_object_type({in: RDF::DC, to: 'type'}) do |index|
        index.as :searchable, :displayable, :facetable
      end
      map.identifier({in: RDF::DC})
    end
  end

  include CurationConcern::Model
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
      :archived_object_type,
    ],
    unique: true
  )

  has_many :generic_files, property: :is_part_of

  after_destroy :after_destroy_cleanup
  def after_destroy_cleanup
    generic_files.each(&:destroy)
  end


end
