class Document < ActiveFedora::Base
  include CurationConcern::Work
  include CurationConcern::WithGenericFiles
  include CurationConcern::WithLinkedResources
  include CurationConcern::WithLinkedContributors
  include CurationConcern::WithRelatedWorks
  include CurationConcern::Embargoable
  include CurationConcern::WithEditors

  include ActiveFedora::RegisteredAttributes

  has_metadata "descMetadata", type: DocumentDatastream

  include CurationConcern::RemotelyIdentifiedByDoi::Attributes

  class_attribute :human_readable_short_description
  self.human_readable_short_description = "Deposit any text-based document (other than an article)."

  def self.valid_types
    [ 'Book',
      'Book Chapter',
      'Document',
      'Report',
      'Pamphlet',
      'Brochure',
      'Manuscript',
      'Letter',
      'Newsletter',
      'Press Release',
      'White Paper' ]
  end

  class_attribute :human_readable_short_description
  self.human_readable_short_description = "Deposit any non-text-based document (other than a dataset or image)."

  attribute :alternate_title,
    datastream: :descMetadata, multiple: true

  attribute :bibliographic_citation,
    datastream: :descMetadata, multiple: false

  attribute :contributor,
    datastream: :descMetadata, multiple: true

  attribute :coverage_spatial,
    datastream: :descMetadata, multiple: true

  attribute :coverage_temporal,
    datastream: :descMetadata, multiple: true

  attribute :date_created,
    default: Date.today.to_s("%Y-%m-%d"),
    datastream: :descMetadata, multiple: false

  attribute :creator,
    datastream: :descMetadata, multiple: true
  
  attribute :date_modified, 
    datastream: :descMetadata, multiple: false

  attribute :date_uploaded,
    datastream: :descMetadata, multiple: false

  attribute :description,
    datastream: :descMetadata, multiple: false

  attribute :identifier,
    datastream: :descMetadata, multiple: true,
    editable: false

  attribute :language,
    default: ['English'],
    datastream: :descMetadata, multiple: true

  attribute :note,
    datastream: :descMetadata, multiple: false,
    editable: true

  attribute :publisher,
    datastream: :descMetadata, multiple: false,
    editable: true

  attribute :publisher_digital,
    default: "University of Cincinnati",
    datastream: :descMetadata, multiple: false,
    editable: true

  attribute :requires,
    datastream: :descMetadata, multiple: false,
    editable: true

  attribute :rights,
    datastream: :descMetadata, multiple: false,
    default: "All rights reserved",
    validates: { presence: { message: 'You must select a license for your work.' } }

  attribute :source,
    datastream: :descMetadata, multiple: false

  attribute :subject,
    datastream: :descMetadata, multiple: true

  attribute :title,
    datastream: :descMetadata, multiple: false,
    validates: { presence: { message: 'Your article must have a title.' } }

  attribute :type, datastream: :descMetadata,
    multiple: false,
    validates: { inclusion: { in: Document.valid_types,
                              allow_blank: true } }

  attribute :files, multiple: true, form: {as: :file}
end
