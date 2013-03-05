require 'spec_helper'
require "ostruct"

describe RepoObject do
  let(:object) {
    OpenStruct.new(
      {
        :pid => "ARCH-SEASIDE:464",
        :url => "https://fedorapprd.library.nd.edu:8443/fedora/get/ARCH-SEASIDE:464/descMetadata",
        :information => "_TEST_",
        :date_added => DateTime.new(2001,-11,-26,-20,-55,-54,'+7'),
        :date_modified => DateTime.new(2001,-11,-26,-20,-55,-54,'+7')
      }
    )
  }
  let(:pid) { "TEST:1234" }

  describe ".create_repo_object" do
    it 'should_create_data_in_purl_database' do
      RepoObject.create_from_fedora_object(object)
      results = RepoObject.where(:filename => pid)
      results.first.pid.should == pid
    end

  end
end
