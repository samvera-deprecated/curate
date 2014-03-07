class Dataset < ActiveFedora::Base
  include CurationConcern::Work
  include CurationConcern::WithGenericFiles
  include CurationConcern::WithLinkedResources
  include CurationConcern::WithLinkedContributors
  include CurationConcern::WithRelatedWorks
  include CurationConcern::Embargoable

  include ActiveFedora::RegisteredAttributes

  has_metadata "descMetadata", type: GenericWorkRdfDatastream

  include CurationConcern::RemotelyIdentifiedByDoi::Attributes

  class_attribute :human_readable_short_description
  self.human_readable_short_description = "One or more files related to your research."

  attribute :title, datastream: :descMetadata,
            multiple: false,
            validates: {presence: { message: 'Your dataset must have a title.' }}

  attribute :rights, datastream: :descMetadata,
            default: "All rights reserved",
            multiple: false,
            validates: {presence: { message: 'You must select a license for your dataset.' }}

  validates_presence_of :contributors, message: "Your dataset must have a contributor."

  attribute :created,                datastream: :descMetadata, multiple: false
  attribute :description,            datastream: :descMetadata, multiple: false
  attribute :date_uploaded,          datastream: :descMetadata, multiple: false
  attribute :date_modified,          datastream: :descMetadata, multiple: false
  attribute :available,              datastream: :descMetadata, multiple: false
  attribute :creator,                datastream: :descMetadata, multiple: false
  attribute :content_format,         datastream: :descMetadata, multiple: false
  attribute :identifier,             datastream: :descMetadata, multiple: false

  attribute :publisher,              datastream: :descMetadata, multiple: true
  attribute :bibliographic_citation, datastream: :descMetadata, multiple: true
  attribute :source,                 datastream: :descMetadata, multiple: true
  attribute :language,               datastream: :descMetadata, multiple: true
  attribute :extent,                 datastream: :descMetadata, multiple: true
  attribute :requires,               datastream: :descMetadata, multiple: true
  attribute :subject,                datastream: :descMetadata, multiple: true

  attribute :files, multiple: true, form: {as: :file},
            hint: "CTRL-Click (Windows) or CMD-Click (Mac) to select multiple files."

end
