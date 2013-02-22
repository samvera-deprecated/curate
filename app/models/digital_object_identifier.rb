class DigitalObjectIdentifier

  attr_accessor :target, :creator, :title, :publisher, :publicationyear
  attr_accessor :description, :rights, :version, :format, :data_size, :contributor, :subject, :name_id, :subtitle, :created_date, :accepted_date, :resource_type, :lang

  # Mandatory fields for creating DOI.
  def data
    "_target: #{target}\ndatacite.creator: #{creator}\ndatacite.title: #{title}\ndatacite.publisher: #{publisher}\ndatacite.publicationyear: #{publicationyear}\n"
  end

  # Step - 1: Create DOI by passing 5 metadata - target, creator, title, publisher, publicationyear
  def create_doi
    response = RestClient.post DoiConfig.url_for_creating_doi, data, :content_type => 'text/plain'
    return response
  end

  # Create DOI or return if already created.
  def doi
    @doi ||= create_doi
    if @doi.include?("success")
      @doi = @doi.split("|")[0].sub("success:", "").strip
    end
    @doi
  end

  # Step - 2: Update the DOI metadata with more attributes. The extra metadata will need to be in the xml format.
  def update_doi
    response = RestClient.post "#{DoiConfig.url_for_updating_doi}#{doi}", sanitize_data, :content_type => 'text/plain; charset=UTF-8', :content_length => sanitize_data.size, :accept => 'text/plain'
    return response
  end

  # This method replaces special characters like %, :, \n and \r in the XML data and appends to the basic metadata which was used while creating DOI in Step - 1.
  def sanitize_data
    data + "datacite: #{create_xml.to_xml.gsub("%", "%25").gsub(":", "%3A").gsub("\n", "%0D%0A").gsub("\r", "")}\n"
  end

  # This method creates XML data which is used for extra metadata other than the 5 metadata which was used in Step - 1.
  def create_xml
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.resource("xmlns" => "http://datacite.org/schema/kernel-2.2", "xmlns:xsi" =>"http://www.w3.org/2001/XMLSchema-instance", "xsi:schemaLocation" => "http://datacite.org/schema/kernel-2.2 http://schema.datacite.org/meta/kernel-2.2/metadata.xsd") {
        xml.identifier(:identifierType => "DOI"){ xml.text doi.sub("doi:", "") }
        xml.creators{
          xml.creator{
            xml.creatorName creator
            xml.nameIdentifier(:nameIdentifierScheme => "ISNI") { xml.text name_id }
          }
        }
        xml.titles{
          xml.title title
          xml.title(:titleType => "Subtitle") { xml.text subtitle}
        }
        xml.publisher publisher
        xml.publicationYear publicationyear
        xml.subjects{
          xml.subject subject
        }
        xml.contributors{
          xml.contributor(:contributorType => "DataManager"){
            xml.contributorName contributor
          }
        }
        xml.dates{
          xml.date(:dateType => "Valid"){ xml.text created_date }
          xml.date(:dateType => "Accepted"){ xml.text accepted_date }
        }
        xml.language lang
        xml.resourceType(:resourceTypeGeneral => "Image"){ xml.text resource_type }
        xml.sizes{
          xml.size data_size
        }
        xml.formats{
          xml.format format
        }
        xml.version version
        xml.rights rights
        xml.descriptions{
          xml.description(:descriptionType => "Other") { xml.text description }
        }
      }
    end
  end
end

