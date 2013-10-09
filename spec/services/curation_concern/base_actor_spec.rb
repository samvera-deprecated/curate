require 'spec_helper'

class FakeCurationConcern
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

  subject {
    CurationConcern::BaseActor.new(curation_concern, user, {})
  }

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
