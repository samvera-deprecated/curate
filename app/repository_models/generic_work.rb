class GenericWork < ActiveFedora::Base
  include CurationConcern::Model
  include CurationConcern::WithGenericFiles
  include CurationConcern::WithLinkedResources
  include CurationConcern::Embargoable
  include CurationConcern::WithAccessRight

  include ActiveFedora::RegisteredAttributes

  has_metadata "descMetadata", type: GenericWorkRdfDatastream

  attribute :title, datastream: :descMetadata,
    multiple: false,
    validates: {presence: { message: 'Your work must have a title.' }}

  attribute :rights, datastream: :descMetadata,
    multiple: false,
    validates: {presence: { message: 'You must select a license for your work.' }}

  attribute :created, datastream: :descMetadata, multiple: false
  attribute :description, datastream: :descMetadata, multiple: false
  attribute :date_uploaded, datastream: :descMetadata, multiple: false
  attribute :date_modified, datastream: :descMetadata, multiple: false
  attribute :available, datastream: :descMetadata, multiple: false
  attribute :archived_object_type, datastream: :descMetadata, multiple: false
  attribute :creator, datastream: :descMetadata, multiple: false
  attribute :content_format, datastream: :descMetadata, multiple: false
  attribute :identifier, datastream: :descMetadata, multiple: false

  attribute :contributor, datastream: :descMetadata, multiple: true
  attribute :publisher, datastream: :descMetadata, multiple: true
  attribute :bibliographic_citation, datastream: :descMetadata, multiple: true
  attribute :source, datastream: :descMetadata, multiple: true
  attribute :language, datastream: :descMetadata, multiple: true
  attribute :extent, datastream: :descMetadata, multiple: true
  attribute :requires, datastream: :descMetadata, multiple: true
  attribute :subject, datastream: :descMetadata, multiple: true

  attribute :thesis_file, multiple: true, form: {as: :file},
    hint: "CTRL-Click (Windows) or CMD-Click (Mac) to select multiple files."

  attribute :linked_resource_url, multiple: true

end
