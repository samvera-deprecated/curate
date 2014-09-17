class Article < ActiveFedora::Base
  include CurationConcern::Work
  include CurationConcern::WithGenericFiles
  include CurationConcern::WithLinkedResources
  include CurationConcern::WithLinkedContributors
  include CurationConcern::WithRelatedWorks
  include CurationConcern::Embargoable
  include CurationConcern::WithEditors

  include ActiveFedora::RegisteredAttributes

  has_metadata "descMetadata", type: ArticleMetadataDatastream

  include CurationConcern::RemotelyIdentifiedByDoi::Attributes

  class_attribute :human_readable_short_description
  self.human_readable_short_description = "Deposit or reference a preprint or published article."

  self.indefinite_article = 'an'

  attribute :abstract,
    datastream: :descMetadata, multiple: false,
    validates: { presence: { message: 'Your Article must have an abstract.' } }

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

  attribute :creator,
    datastream: :descMetadata, multiple: true,
    validates: { multi_value_presence: { message: "Your article must have an author." } }

  attribute :date_created,
    default: Date.today.to_s("%Y-%m-%d"),
    datastream: :descMetadata, multiple: false

  attribute :date_modified, 
    datastream: :descMetadata, multiple: false

  attribute :date_uploaded,
    datastream: :descMetadata, multiple: false

  attribute :doi,
    datastream: :descMetadata, multiple: false,
    editable: false

  attribute :identifier,
    datastream: :descMetadata, multiple: true,
    editable: false

  attribute :issn,
    datastream: :descMetadata, multiple: false,
    editable: true

  attribute :journal_title,
    datastream: :descMetadata, multiple: false

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
    datastream: :descMetadata, multiple: false,
    editable: true

  attribute :requires,
    datastream: :descMetadata, multiple: false

  attribute :rights,
    datastream: :descMetadata, multiple: false,
    default: "All rights reserved",
    validates: { presence: { message: 'You must select a license for your work.' } }

  attribute :subject,
    datastream: :descMetadata, multiple: true

  attribute :title,
    datastream: :descMetadata, multiple: false,
    validates: { presence: { message: 'Your article must have a title.' } }

  attribute :files,
    multiple: true, form: {as: :file}, label: "Upload Files"
end
