require 'spec_helper'

class FakeCurationConcern < ActiveFedora::Base
  include CurationConcern::Model

  def date_uploaded= date
  end

  def valid?
    true
  end

  def save
    valid?
  end
end

describe CurationConcern::BaseActor do
  let(:curation_concern) { FakeCurationConcern.new }
  let(:user) { FactoryGirl.create(:user) }
  let(:attributes) { Hash.new }

  subject {
    CurationConcern::BaseActor.new(curation_concern, user, attributes)
  }

  describe 'apply_creation_data_to_curation_concern' do
    before { subject.send(:apply_creation_data_to_curation_concern) }
    context 'depositing for yourself' do
      it "should set the depositor and owner" do
        expect(curation_concern.depositor).to eq user.user_key
        expect(curation_concern.owner).to eq user.user_key
      end
    end
    context 'depositing on behalf of someone else' do
      let(:attributes) { {owner: 'jcoyne'} }
      it "should set the depositor and owner" do
        expect(curation_concern.depositor).to eq user.user_key
        expect(curation_concern.owner).to eq 'jcoyne'
      end
    end
  end

  describe '#create' do
    before do
      subject.stub(:apply_creation_data_to_curation_concern)
      subject.stub(:apply_save_data_to_curation_concern)
    end

    describe 'success' do
      it 'returns true' do
        subject.stub(:assign_remote_identifier_if_applicable).and_return(true)
        subject.create.should be_true
      end
    end

    describe 'failure' do
      it 'returns false' do
        curation_concern.should_receive(:valid?).and_return(false)
        subject.create.should be_false
      end
    end
  end

  describe '#update' do
    before do
      subject.stub(:apply_save_data_to_curation_concern)
    end

    describe 'success' do
      it 'returns true' do
        subject.update.should be_true
      end
    end

    describe 'failure' do
      it 'returns false' do
        curation_concern.should_receive(:valid?).and_return(false)
        subject.update.should be_false
      end
    end
  end

end
