class DigitalObjectIdentifier

=begin
  # mandatory fields for creating DOI
  def initialize(target, creator, title, publisher, publicationyear)
    @target = target
    @creator = creator
    @title = title
    @publisher = publisher
    @publicationyear = publicationyear
  end
=end
  attr_accessor :target, :creator, :title, :publisher, :publicationyear

  def data
    "_target: #{target}\ndatacite.creator: #{creator}\ndatacite.title: #{title}\ndatacite.publisher: #{publisher}\ndatacite.publicationyear: #{publicationyear}\n"
  end

  def create_doi
    response = RestClient.post DoiConfig.url_for_creating_doi, data, :content_type => 'text/plain'
    return response
  end

  def doi
    @doi ||= create_doi
    if @doi.include?("success")
      @doi = @doi.split("|")[0].sub("success:", "").strip
    end
    @doi
  end

  def update_doi
    response = RestClient.post "#{DoiConfig.url_for_updating_doi}#{doi}", sanitize_data, :content_type => 'text/plain; charset=UTF-8', :content_length => sanitize_data.size, :accept => 'text/plain'
    return response
  end

  def sanitize_data
    data + "datacite: #{create_xml.to_xml.gsub("%", "%25").gsub(":", "%3A").gsub("\n", "%0D%0A").gsub("\r", "")}\n"
  end

  def create_xml
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.resource("xmlns" => "http://datacite.org/schema/kernel-2.2", "xmlns:xsi" =>"http://www.w3.org/2001/XMLSchema-instance", "xsi:schemaLocation" => "http://datacite.org/schema/kernel-2.2 http://schema.datacite.org/meta/kernel-2.2/metadata.xsd") {
        xml.identifier(:identifierType => "DOI"){ xml.text doi.sub("doi:", "") }
        xml.creators{
          xml.creator{
            xml.creatorName creator
            xml.nameIdentifier(:nameIdentifierScheme => "ISNI") { xml.text "9999 9999 9999 9999" } #name_id
          }
        }
        xml.titles{
          xml.title title
          xml.title(:titleType => "Subtitle") { xml.text "Colonial Currency" } #subtitle
        }
        xml.publisher publisher
        xml.publicationYear publicationyear
        xml.subjects{
          xml.subject "Special Collection" #subject
        }
        xml.contributors{
          xml.contributor(:contributorType => "DataManager"){
            xml.contributorName "Smith, John" #contibutor
          }
        }
        xml.dates{
          xml.date(:dateType => "Valid"){ xml.text "2011-04-05" } #date
          xml.date(:dateType => "Accepted"){ xml.text "2012-01-01" } #date
        }
        xml.language "en" #lang
        xml.resourceType(:resourceTypeGeneral => "Image"){ xml.text "Animation" } #resource_type
        xml.sizes{
          xml.size "128kb" #data_size
        }
        xml.formats{
          xml.format "text/plain"
        }
        xml.version "1.0"
        xml.rights "Open Database License [ODbL]" #rights
        xml.descriptions{
          xml.description(:descriptionType => "Other") { xml.text "The current xml-example for a DataCite record is the official example from the documentation.<br/>Please look on datcite.org to find the newest versions of sample data and schemas."} #description
        }
      }
    end
  end
end

