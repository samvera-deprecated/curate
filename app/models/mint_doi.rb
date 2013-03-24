class MintDoi

  attr_reader :fedora_object

  class MissingDataError < RuntimeError
    def initialize(error_message)
      super(error_message)
    end
  end

  def initialize(obj_id)
    @fedora_object = retreive_fedora_object(obj_id)
  end

  # Return DOI if already stored in fedora object. If not create a new DOI and store it in the fedora object.
  def create_or_retrieve_doi
    if (doi = fedora_object.identifier).present?
      return doi
    end

    fedora_object.identifier = digital_object_identifier.doi
    fedora_object.save!
    return fedora_object.identifier
  end

  private

  def digital_object_identifier
    @digital_object_identifier ||= DigitalObjectIdentifier.new

    @digital_object_identifier.target = create_or_retreive_purl
    @digital_object_identifier.title = fedora_object.title
    @digital_object_identifier.creator = fedora_object.creator
    @digital_object_identifier.publisher = "Hesburgh Library - University of Notre Dame"
    @digital_object_identifier.publicationyear = Time.now.year.to_s

    @digital_object_identifier
  end

  # Obtain the actual content-model type and load the object.
  def retreive_fedora_object(obj_id)
    ActiveFedora::Base.find(obj_id, cast: true)
  end

  # Create or retrieve purl link for the given fedora ID.
  def create_or_retreive_purl
    raise MissingDataError.new("Title and Creator fields cannot be empty.") if fedora_object.title.blank? || fedora_object.creator.blank?
    mint_purl = MintPurl.new(fedora_object)
    mint_purl.create_or_retreive_purl
  end
end
