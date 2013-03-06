require 'spec_helper'

describe CurationConcern::SeniorThesisActor do
  let(:pid) { CurationConcern.mint_a_pid }
  let(:user) { FactoryGirl.create(:user) }
  let(:curation_concern) { SeniorThesis.new(pid: pid)}
  let(:thesis_file_path) { __FILE__ }
  let(:thesis_file) { Rack::Test::UploadedFile.new(thesis_file_path, 'text/plain', false)}
  subject {
    CurationConcern.actor(curation_concern, user, attributes)
  }
  describe '#create' do
    let(:attributes) {
      FactoryGirl.attributes_for(:senior_thesis).tap {|a|
        a[:thesis_file] = thesis_file
        a[:visibility] = 'psu'
      }
    }
    describe 'valid attributes' do
      let(:perm_matcher) {
        lambda {|perm| perm[:type] == 'group' && perm[:name]=='registered' }
      }
      before(:all) do
        subject.create!
      end
      it do
        expect(curation_concern).to be_persisted
        curation_concern.date_uploaded.should == Date.today
        curation_concern.date_modified.should == Date.today
        curation_concern.depositor.should == user.user_key
        curation_concern.creator.should == user.name

        # TODO - Not exactly certain what this is about; Need reference
        # Also, can we make a permissions object that is not hash driven?
        curation_concern.permissions.select(&perm_matcher).count == 1

        new_curation_concern = curation_concern.class.find(curation_concern.pid)

        new_curation_concern.generic_files.count.should == 1
        # Sanity test to make sure the file we uploaded is stored and has same permission as parent.
        senior_thesis_file = new_curation_concern.generic_files.first
        senior_thesis_file.content.content.should == thesis_file.read
        senior_thesis_file.filename.should == File.basename(thesis_file_path)
        senior_thesis_file.to_s.should == 'Senior Thesis'
        senior_thesis_file.permissions.select(&perm_matcher).count == 1
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
        subject.update!
      end
      it do
        expect(curation_concern).to be_persisted
        curation_concern.permissions.select{|r| r[:type] == 'group' && r[:name]=='public'}.count == 1
      end

    end
  end

end
