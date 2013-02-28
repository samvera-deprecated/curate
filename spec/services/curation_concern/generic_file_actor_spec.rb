require 'spec_helper'

describe CurationConcern::GenericFileActor do
  let(:user) { FactoryGirl.create(:user) }
  let(:generic_file) {
    FactoryGirl.create_generic_file(:senior_thesis, user)
  }
  let(:revised_file) { Rack::Test::UploadedFile.new(__FILE__, 'text/plain', false)}
  let(:revised_file_content) { File.read(revised_file)}
  let(:updated_title) { Time.now.to_s }
  let(:attributes) { { revised_file: revised_file, title: updated_title } }

  subject {
    CurationConcern::GenericFileActor.new(generic_file, user, attributes)
  }

  describe '#update' do
    it do
      generic_file.title.should_not == updated_title
      generic_file.content.content.should_not == revised_file_content
      subject.update
      generic_file.title.should == updated_title
      generic_file.content.content.should == revised_file_content
    end
  end
end
