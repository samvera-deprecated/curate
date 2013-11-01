class Document < GenericWork

  has_metadata "descMetadata", type: DocumentDatastream

  self.human_readable_short_description = "Deposit any text-based document (other than an article)."

  self.indefinite_article = 'an'
  self.contributor_label = 'Author'
  validates_presence_of :contributors, message: "Your #{human_readable_type.downcase} must have #{label_with_indefinite_article}."

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

end
