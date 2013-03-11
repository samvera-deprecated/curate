require 'spec_helper'

# https://github.com/bblimke/webmock
require 'webmock/rspec'

describe MintPurl do

  before :each do
    @mint_purl = MintPurl.new
  end

  let(:pid) { "TEST:1234" }

  let(:bad_fed_obj) { }

  let(:fed_obj) {
    OpenStruct.new(
      {
        :pid => pid,
        :information => "_TEST_",
        :date_added => DateTime.new(2001,-11,-26,-20,-55,-54,'+7'),
        :date_modified => DateTime.new(2001,-11,-26,-20,-55,-54,'+7')
      }
    )
  }

  let(:expected_purl_link) { "http://localhost:3000/view/1/TEST:1234" }

  describe 'create_or_retreive_purl' do
    it 'raises exception if fedora object is nil' do
      ActiveFedora::Base.stub(:find).with(pid, cast: true).and_return(bad_fed_obj)
      expect { @mint_purl.create_or_retreive_purl(bad_fed_obj) }.to raise_error(MintPurl::PurlError)
    end

    it 'should return purl link' do
      ActiveFedora::Base.stub(:find).with(pid, cast: true).and_return(fed_obj)
      @mint_purl.create_or_retreive_purl(fed_obj).should == expected_purl_link
    end
  end

end
