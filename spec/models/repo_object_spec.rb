require 'spec_helper'
require "ostruct"

describe RepoObject do
  before :each do
		@object = OpenStruct.new(
			{
				:pid => "TEST:1234",
				:url => "https://fedorapprd.library.nd.edu:8443/fedora/get/ARCH-SEASIDE:464/descMetadata",
				:information => "_TEST_",
				:date_added => DateTime.new(2001,-11,-26,-20,-55,-54,'+7'),
				:date_modified => DateTime.new(2001,-11,-26,-20,-55,-54,'+7')
			}
		)
	end

	describe ".create_repo_object" do
		pid = "TEST:1234"
		it 'should_not_contain_the_data_in_purl_database' do
			results = RepoObject.where(:filename => pid)
			puts "Result: #{results}"
			results.should == []
		end

		it 'should_create_data_in_purl_database' do
			RepoObject.create_repo_object(@object)
			results = RepoObject.where(:filename => pid)
			puts "Result: #{results}"
			results.first.pid.should == pid
		end

	end

	after :all do
		RepoObject.delete_all
	end
end
