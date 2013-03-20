require 'spec_helper'

describe CurationConcern do
  subject {CurationConcern}
  it 'can mint_a_pid' do
    subject.should respond_to(:mint_a_pid)
  end

  describe '.actor' do
    it 'finds an actor by for a SeniorThesis' do
      subject.actor(SeniorThesis.new, User.new, {}).should(
        be_kind_of(CurationConcern::SeniorThesisActor)
      )
    end

    it 'raise an exception if there is no actor' do
      expect {
        subject.actor("", User.new, {})
      }.to raise_error(NameError)
    end
  end

  describe '.attach_file' do
    let(:file) { Rack::Test::UploadedFile.new(__FILE__, 'text/plain', false) }
    let(:user) { FactoryGirl.create(:user) }
    let(:generic_file) { GenericFile.new }
    let(:curation_concern) { FactoryGirl.create_curation_concern(:senior_thesis, user)}
    it 'works with a string' do
      actor = CurationConcern.actor(generic_file, user, {batch_id: curation_concern.pid, file: file})
      actor.create!
      generic_file.content.content.should == file.read
    end
  end
end
