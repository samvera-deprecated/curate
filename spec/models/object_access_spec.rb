require 'spec_helper'
require 'ostruct'

describe ObjectAccess do

  let(:purl) {
    OpenStruct.new(
      {
        :purl_id => 9999,
        :repo_object_id => 9999,
        :access_count => 0,
        :date_created => DateTime.new(2001,-11,-26,-20,-55,-54,'+7')
      }
    )
  }

  describe '.create_from_purl' do
    it 'should_create_data_in_purl_database' do
      ObjectAccess.create_from_purl(purl)
      result = ObjectAccess.first
      result.repo_object_id.should == purl.repo_object_id
    end
  end
end
