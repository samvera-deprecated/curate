require 'spec_helper'

describe CurationConcern::Actions do
  let(:pid) { CurationConcern.mint_a_pid }
  let(:curation_concern) { SeniorThesis.new(pid: pid)}
  let(:user) { FactoryGirl.create(:user) }
  let(:thesis_file) { Rack::Test::UploadedFile.new(__FILE__, 'text/plain', false)}
  describe '.create_metadata' do
    let(:attributes) {
      FactoryGirl.attributes_for(:senior_thesis).tap {|a|
        a[:thesis_file] = thesis_file
      }
    }
    describe 'valid attributes' do
      before(:all) do
        CurationConcern::Actions.create_metadata(curation_concern, user, attributes)
      end
      it 'should persist' do
        expect(curation_concern).to be_persisted
      end
      it 'applies depositor metadata' do
        curation_concern.depositor.should == user.user_key
      end
      it 'assigns a creator' do
        curation_concern.creator.should == user.name
      end
      it 'assigns attributes' do
        attributes.each do |key, value|
          curation_concern.send(key).should == value
        end
      end
      it 'creates a generic file' do
        new_curation_concern = curation_concern.class.find(curation_concern.pid)
        new_curation_concern.generic_files.count.should == 1
        # Sanity test to make sure the file we uploaded is stored.
        new_curation_concern.generic_files.first.content.content.should == thesis_file.read
      end
    end
  end
end
