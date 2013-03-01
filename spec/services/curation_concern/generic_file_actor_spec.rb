require 'spec_helper'

describe CurationConcern::GenericFileActor do
  let(:user) { FactoryGirl.create(:user) }
  let(:curation_concern) {
    FactoryGirl.create_curation_concern(:senior_thesis, user)
  }
  let(:generic_file) {
    FactoryGirl.create_generic_file(curation_concern, user)
  }
  let(:file) { Rack::Test::UploadedFile.new(__FILE__, 'text/plain', false)}
  let(:file_content) { File.read(file)}
  let(:title) { Time.now.to_s }
  let(:attributes) { { file: file, title: title } }

  subject {
    CurationConcern::GenericFileActor.new(generic_file, user, attributes)
  }

  describe '#update!' do
    it do
      generic_file.title.should_not == title
      generic_file.content.content.should_not == file_content
      expect {
        subject.update!
      }.to change {generic_file.versions.count}.by(1)
      generic_file.title.should == title
      generic_file.to_s.should == title
      generic_file.content.content.should == file_content
    end
  end
end
