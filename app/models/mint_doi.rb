class MintDoi

  attr_reader :fedora_object

  def initialize(obj_id)
    @fedora_object = retreive_fedora_object(obj_id)
  end

  # Return DOI if already stored in fedora object. If not create a new DOI and store it in the fedora object.
  def create_or_retreive_doi
    if !(doi = fedora_object.identifier).nil?
      return doi
    end

    return nil if fedora_object.url.nil? && fedora_object.title.nil? && fedora_object.creator.nil?

    fedora_object.identifier = digital_object_identifier.doi
    fedora_object.save
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
    mint_purl = MintPurl.new
    mint_purl.create_or_retreive_purl(fedora_object)
  end
end
