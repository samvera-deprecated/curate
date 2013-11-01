require 'spec_helper'

class FakeCurationConcern < ActiveFedora::Base
  include CurationConcern::Work

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
    let(:proxy_user) { FactoryGirl.create(:user) }
    before do
      user.can_receive_deposits_from << proxy_user
      subject.send(:apply_creation_data_to_curation_concern)
    end
    context 'depositing for yourself' do
      it "should set the depositor and owner" do
        expect(curation_concern.depositor).to eq user.user_key
        expect(curation_concern.owner).to eq user.user_key
      end
    end
    context 'depositing on behalf of someone you have proxy access for' do
      subject {
        CurationConcern::BaseActor.new(curation_concern, proxy_user, attributes)
      }
      let(:attributes) { {owner: user.user_key} }
      it "should set the depositor and owner" do
        expect(curation_concern.depositor).to eq proxy_user.user_key
        expect(curation_concern.owner).to eq user.user_key
        expect(curation_concern.edit_users).to include(user.user_key, proxy_user.user_key)
      end
    end
    context 'depositing on behalf of someone you do not have proxy access for' do
      let(:attributes) { {owner: 'jcoyne'} }
      it "should ignore the owner attribute" do
        expect(curation_concern.depositor).to eq user.user_key
        expect(curation_concern.owner).to eq user.user_key
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
