class GenericWork < ActiveFedora::Base
  include CurationConcern::Model
  include CurationConcern::WithGenericFiles
  include CurationConcern::WithLinkedResources
  include CurationConcern::Embargoable
  include CurationConcern::WithAccessRight

  has_metadata "descMetadata", type: GenericWorkRdfDatastream

  delegate_to(
    :descMetadata,
    [
      :title,
      :created,
      :description,
      :date_uploaded,
      :date_modified,
      :available,
      :archived_object_type,
      :creator,
      :content_format,
      :identifier,
      :rights
    ],
    unique: true
  )
  delegate_to(
    :descMetadata,
    [
      :contributor,
      :publisher,
      :bibliographic_citation,
      :source,
      :language,
      :extent,
      :requires,
      :subject
    ]
  )

  validates :title, presence: { message: 'Your thesis must have a title.' }
  validates :rights, presence: { message: 'You must select a license for your work.' }

  attr_accessor :thesis_file
  attr_accessor :linked_resource_url

end
