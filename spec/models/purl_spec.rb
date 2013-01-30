require 'spec_helper'

describe Purl do
	before :each do
		@repo_object = RepoObject.new(
			{
				:repo_object_id => 9999,
				:pid => "ARCH-SEASIDE:464",
				:date_added => DateTime.new(2001,-11,-26,-20,-55,-54,'+7'),
				:date_modified => DateTime.new(2001,-11,-26,-20,-55,-54,'+7'),
				:url => "https://fedorapprd.library.nd.edu:8443/fedora/get/ARCH-SEASIDE:464/descMetadata",
				:information => "_TEST_"
			}
		)
	end
  describe '.create_from_repo_object' do
		it 'should_not_contain_data_in_purl_database' do
			Purl.all.should == []
		end

		it 'should_create_data_in_purl_database' do
			Purl.create_from_repo_object(@repo_object)
			result = Purl.all.first
			result.repo_object_id.should == @repo_object.repo_object_id
		end
	end

	after :all do
		Purl.delete_all
		RepoObject.delete_all
	end
end
