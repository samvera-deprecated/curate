class Document < GenericWork

  has_metadata "descMetadata", type: DocumentDatastream

  self.human_readable_short_description = "Deposit any text-based document (other than an article)."

  self.indefinite_article = 'an'
  self.contributor_label = 'Author'

  def self.valid_types
    [
      'Book',
      'Book Chapter',
      'Brochure',
      'Document',
      'Letter',
      'Manuscript',
      'Newsletter',
      'Pamphlet',
      'Presentation',
      'Press Release',
      'Report',
      'White Paper'
    ]
  end

  attribute :type, datastream: :descMetadata,
    multiple: false,
    validates: { inclusion: { in: Document.valid_types,
                              allow_blank: true } }
 
  attribute :date_created,               datastream: :descMetadata, multiple: true, default: Date.today.to_s("%Y-%m-%d")
  attribute :date_uploaded,              datastream: :descMetadata, multiple: false
  attribute :date_modified,              datastream: :descMetadata, multiple: false
  attribute :alternate_title,            datastream: :descMetadata, multiple: true
  attribute :creator,                    datastream: :descMetadata, multiple: true
  attribute :contributor_institution,    datastream: :descMetadata, multiple: true
  attribute :abstract,                   datastream: :descMetadata, multiple: false
  attribute :repository_name,            datastream: :descMetadata, multiple: true
  attribute :collection_name,            datastream: :descMetadata, multiple: true
  attribute :temporal_coverage,          datastream: :descMetadata, multiple: true
  attribute :spatial_coverage,           datastream: :descMetadata, multiple: true
  attribute :permission,                 datastream: :descMetadata, multiple: false
  attribute :size,                       datastream: :descMetadata, multiple: true
  attribute :format,                     datastream: :descMetadata, multiple: false
  attribute :recommended_citation,       datastream: :descMetadata, multiple: true
  attribute :identifier,                 datastream: :descMetadata, multiple: false
  attribute :doi,                        datastream: :descMetadata, multiple: false
end
