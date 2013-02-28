require 'spec_helper'

describe CurationConcern::SeniorThesisActor do
  let(:pid) { CurationConcern.mint_a_pid }
  let(:user) { FactoryGirl.create(:user) }
  let(:curation_concern) { SeniorThesis.new(pid: pid)}
  let(:thesis_file) { Rack::Test::UploadedFile.new(__FILE__, 'text/plain', false)}
  subject {
    CurationConcern::SeniorThesisActor.new(curation_concern, user, attributes)
  }
  describe '#create' do
    let(:attributes) {
      FactoryGirl.attributes_for(:senior_thesis).tap {|a|
        a[:thesis_file] = thesis_file
        a[:visibility] = 'psu'
      }
    }
    describe 'valid attributes' do
      before(:all) do
        subject.create
      end
      it do
        expect(curation_concern).to be_persisted
        curation_concern.date_uploaded.should == Date.today
        curation_concern.date_modified.should == Date.today
        curation_concern.depositor.should == user.user_key
        curation_concern.creator.should == user.name
        attributes.each do |key, value|
          curation_concern.send(key).should == value
        end
        curation_concern.permissions.select{|r| r[:type] == 'group' && r[:name]=='registered'}.count == 1

        new_curation_concern = curation_concern.class.find(curation_concern.pid)
        new_curation_concern.generic_files.count.should == 1
        # Sanity test to make sure the file we uploaded is stored.
        new_curation_concern.generic_files.first.content.content.should == thesis_file.read
      end
    end
  end

  describe '#update' do
    let(:attributes) {
      FactoryGirl.attributes_for(:senior_thesis).tap {|a|
        a[:visibility] = 'open'
      }
    }
    describe 'valid attributes' do
      before(:all) do
        curation_concern.apply_depositor_metadata(user.user_key)
        subject.update
      end
      it do
        expect(curation_concern).to be_persisted
        curation_concern.permissions.select{|r| r[:type] == 'group' && r[:name]=='public'}.count == 1
      end

    end
  end

end
