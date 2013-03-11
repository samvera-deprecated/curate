require 'spec_helper'

describe MintDoi do

  before :each do
    WebMock.disable_net_connect!
  end

  after :each do
    WebMock.allow_net_connect!
  end

  def stub_http_for_initial_url(options = {} )
    request_url = DoiConfig.url_for_creating_doi
    if options[:to_timeout]
      stub_request(:get, request_url).to_timeout
    else
      headers = options[:headers] || {}
      status = options[:status] || 200
      stub_request(:post, request_url).
      to_return(
        {
          body: "doi:10.5072/FK2K361NJ | ack:10.5072/FK2K361NJ",
          status: status,
          headers: headers
        }
      )
    end
  end

  let(:pid) { "und:j3860692c" }

  let(:mint_doi) { MintDoi.new(pid)}

  let(:fedora_object){
    OpenStruct.new(
      {
        :pid => pid,
        :date_added => DateTime.new(2001,-11,-26,-20,-55,-54,'+7'),
        :date_modified => DateTime.new(2001,-11,-26,-20,-55,-54,'+7'),
        :url => "https://localhost:8983/fedora/get/und:99hijk99",
        :information => "_TEST_",
        :title => "Notre Dame Test",
        :creator => "DLIS"
      }
    )
  }

  let(:expected_doi) { "doi:10.5072/FK2K361NJ" }

  describe 'create_or_retreive_purl' do

    it 'should_return_digital_object_identifier' do
      ActiveFedora::Base.stub(:find).with(pid, cast: true).and_return(fedora_object)
      stub_http_for_initial_url
      mint_doi.create_or_retrieve_doi.should include(expected_doi)
    end

  end

end
