require 'spec_helper'

describe CurationConcern::BaseActor do
  let(:pid) { CurationConcern.mint_a_pid }
  let(:user) { FactoryGirl.create(:user) }
  let(:curation_concern) { SeniorThesis.new(pid: pid)}
  let(:thesis_file) { Rack::Test::UploadedFile.new(__FILE__, 'text/plain', false)}
  subject {
    CurationConcern::BaseActor.new(curation_concern, user, attributes)
  }
  describe '#create_metadata' do
    let(:attributes) {
      FactoryGirl.attributes_for(:senior_thesis).tap {|a|
        a[:thesis_file] = thesis_file
        a[:visibility] = 'psu'
      }
    }
    describe 'valid attributes' do
      before(:all) do
        subject.create_metadata
      end
      it 'should persist' do
        expect(curation_concern).to be_persisted
      end
      it 'should have a date_uploaded' do
        curation_concern.date_uploaded.should == Date.today
      end
      it 'should have a date_modified' do
        curation_concern.date_modified.should == Date.today
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
      it 'should have restricted permission' do
        curation_concern.permissions.select{|r| r[:type] == 'group' && r[:name]=='registered'}.count == 1
      end
      it 'creates a generic file' do
        new_curation_concern = curation_concern.class.find(curation_concern.pid)
        new_curation_concern.generic_files.count.should == 1
        # Sanity test to make sure the file we uploaded is stored.
        new_curation_concern.generic_files.first.content.content.should == thesis_file.read
      end
    end
  end

  describe '#update_metadata' do
    let(:attributes) {
      FactoryGirl.attributes_for(:senior_thesis).tap {|a|
        a[:visibility] = 'open'
      }
    }
    describe 'valid attributes' do
      before(:all) do
        curation_concern.apply_depositor_metadata(user.user_key)
        subject.update_metadata
      end
      it 'should persist' do
        expect(curation_concern).to be_persisted
      end

      it 'should have full permission' do
        curation_concern.permissions.select{|r| r[:type] == 'group' && r[:name]=='public'}.count == 1
      end

    end
  end
end
