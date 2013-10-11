class Document < GenericWork
  has_metadata "descMetadata", type: DocumentDatastream

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
