require 'spec_helper'

describe DigitalObjectIdentifier do

  before :each do
    @doi = DigitalObjectIdentifier.new
  end

  describe 'create_doi' do
    it 'should_not_create_digital_object_identifier' do
      expect { @doi.create_doi }.to raise_error(RestClient::BadRequest)
    end

    it 'should_create_digital_object_identifier' do
      @doi.target          = "https://fedorapprd.library.nd.edu:8443/fedora/get/RBSC-CURRENCY:671/"
      @doi.title           = "Notre Dame Test"
      @doi.creator         = "Comstock, Adam"
      @doi.publisher       = "Hesburgh Library - University of Notre Dame"
      @doi.publicationyear = "2011"
      response = @doi.create_doi
      response.should include("success: doi:10.5072/FK2")
    end
  end

  describe 'update_doi' do
    it 'should_add_more_metadata' do
      @doi.target          = "https://fedorapprd.library.nd.edu:8443/fedora/get/RBSC-CURRENCY:671/"
      @doi.title           = "Notre Dame Test"
      @doi.creator         = "Comstock, Adam"
      @doi.publisher       = "Hesburgh Library - University of Notre Dame"
      @doi.publicationyear = "2011"
      @doi.description     = "Description of content"
      @doi.rights          = ""
      @doi.version         = "1.1"
      @doi.format          = "text/plain"
      @doi.data_size       = "128kb"
      @doi.contributor     = "RNB"
      @doi.subject         = "TEST"
      @doi.name_id         = "87fs89ds"
      @doi.subtitle        = "Currency"
      @doi.created_date    = "2011-12-1"
      @doi.accepted_date   = "2012-01-31"
      @doi.resource_type   = "Test"
      @doi.lang            = "eng"
      response = @doi.update_doi
      response.should include("success: doi:10.5072/FK2")
    end
  end

end
