class Document < GenericWork

  has_metadata "descMetadata", type: DocumentDatastream

  self.human_readable_short_description = "Deposit any text-based document (other than an article)."

  self.indefinite_article = 'an'
  self.contributor_label = 'Author'
  validates_presence_of :contributor, message: "Your #{human_readable_type.downcase} must have #{label_with_indefinite_article}."

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

  attribute :type, datastream: :descMetadata,
    multiple: false,
    validates: { inclusion: { in: Document.valid_types,
                              allow_blank: true } }

  attribute :alternate_title,            datastream: :descMetadata, multiple: false
  attribute :contributor_institution,    datastream: :descMetadata, multiple: true
  attribute :abstract,                   datastream: :descMetadata, multiple: false
  attribute :repository_name,            datastream: :descMetadata, multiple: false
  attribute :collection_name,            datastream: :descMetadata, multiple: false
  attribute :coverage_temporal,          datastream: :descMetadata, multiple: false
  attribute :coverage_spatial,           datastream: :descMetadata, multiple: false
  attribute :permissions,                datastream: :descMetadata, multiple: false
  attribute :size,                       datastream: :descMetadata, multiple: false
  attribute :format,                     datastream: :descMetadata, multiple: false
  attribute :recommended_citation,       datastream: :descMetadata, multiple: true
  attribute :identifier,                 datastream: :descMetadata, multiple: false
  attribute :doi,                        datastream: :descMetadata, multiple: false
end
