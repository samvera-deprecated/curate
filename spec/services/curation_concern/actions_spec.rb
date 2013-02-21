require 'spec_helper'

describe CurationConcern::Actions do
  let(:pid) { CurationConcern.mint_a_pid }
  let(:curation_concern) { SeniorThesis.new(pid: pid)}
  let(:user) { FactoryGirl.create(:user) }
  describe '.create_metadata' do
    let(:attributes) {
      FactoryGirl.attributes_for(:senior_thesis).tap {|a|
        # a[:thesis_file] = fixture_file_upload
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

      end
    end
  end
end
