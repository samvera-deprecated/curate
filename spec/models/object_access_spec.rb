require 'spec_helper'

describe ObjectAccess do

	before :each do
		@purl = Purl.new(
			{
				:purl_id => 9999,
				:repo_object_id => 9999,
				:access_count => 0,
				:date_created => DateTime.new(2001,-11,-26,-20,-55,-54,'+7')
			}
		)
	end

  describe '.create_from_purl' do
		it 'should_not_contain_the_data_in_purl_database' do
			ObjectAccess.all.should == []
		end

		it 'should_create_data_in_purl_database' do
			ObjectAccess.create_from_purl(@purl)
			result = ObjectAccess.all.first
			result.repo_object_id.should == @purl.repo_object_id
		end
	end
	after :all do
		Purl.delete_all
		ObjectAccess.delete_all
	end
end
