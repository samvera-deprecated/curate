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
      @doi.publisher       = "University of Notre Dame - Libraries"
      @doi.publicationyear = "2011"
      response = @doi.create_doi
      response.should include("success: doi:10.5072/FK2")
    end
  end
end
