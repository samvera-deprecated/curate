require 'spec_helper'

describe CurationConcern::GenericFileActor do
  let(:user) { FactoryGirl.create(:user) }
  let(:parent) {
    FactoryGirl.create_curation_concern(:senior_thesis, user)
  }
  let(:file_path) { __FILE__ }
  let(:file) { Rack::Test::UploadedFile.new(file_path, 'text/plain', false)}
  let(:file_content) { File.read(file)}
  let(:title) { Time.now.to_s }
  let(:attributes) {
    { file: file, title: title, visibility: 'psu' }
  }

  subject {
    CurationConcern::GenericFileActor.new(generic_file, user, attributes)
  }

  describe '#create!' do
    let(:generic_file) { GenericFile.new.tap {|gf| gf.batch = parent } }
    let(:reloaded_generic_file) {
      generic_file.class.find(generic_file.pid)
    }
    describe 'with a file' do
      it 'succeeds if attributes are given' do
        expect {
          subject.create!
        }.to change {
          parent.class.find(parent.pid).generic_files.count
        }.by(1)

        reloaded_generic_file.batch.should == parent
        reloaded_generic_file.to_s.should == title
        reloaded_generic_file.filename.should == File.basename(__FILE__)

        expect(reloaded_generic_file.to_solr['read_access_group_t']).to eq(['registered'])
      end

      it 'fails if no batch is provided' do
        generic_file.batch = nil
        expect {
          expect {
            subject.create!
          }.to raise_error(ActiveFedora::RecordInvalid)
        }.to_not change { GenericFile.count }
      end
    end

    describe 'without a file' do
      let(:file) { nil }
      it 'fails if no batch is provided' do
        expect{
          expect {
            subject.create!
          }.to raise_error(ActiveFedora::RecordInvalid)
        }.to_not change { GenericFile.count }
      end
    end
  end

  describe '#update!' do
    let(:generic_file) {
      FactoryGirl.create_generic_file(parent, user)
    }
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
