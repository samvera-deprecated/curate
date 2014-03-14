require 'spec_helper'

describe CurationConcern::GenericFileActor do
  let(:user) { FactoryGirl.create(:user) }
  let(:parent) { FactoryGirl.create_curation_concern(:generic_work, user) }
  let(:file_path) { __FILE__ }
  let(:mime_type) { 'application/x-ruby'}
  let(:file) { Rack::Test::UploadedFile.new(file_path, mime_type, false)}
  let(:file_content) { File.read(file_path)}
  let(:title) { Time.now.to_s }
  let(:cloud_resource_url){ {"selected_files"=>{"0"=>{"url"=>"file://#{file_path}", "expires"=>"nil"}}}}
  let(:curation_concern) { GenericWork.new(pid: CurationConcern.mint_a_pid )}
  let (:cloud_resource) { CloudResource.new(curation_concern, user, cloud_resource_url)}

  let(:attributes) {
    { file: file, title: title, visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED }
  }

  subject {
    CurationConcern::GenericFileActor.new(generic_file, user, attributes)
  }

  describe '#create' do
    let(:generic_file) { GenericFile.new.tap {|gf| gf.batch = parent } }
    let(:reloaded_generic_file) {
      generic_file.class.find(generic_file.pid)
    }

    describe 'with a file' do
      it 'succeeds if attributes are given' do
        return_value = nil
        expect {
          return_value = subject.create
        }.to change {
          parent.class.find(parent.pid).generic_files.count
        }.by(1)

        reloaded_generic_file.batch.should == parent
        reloaded_generic_file.to_s.should == title
        reloaded_generic_file.filename.should == File.basename(__FILE__)

        expect(reloaded_generic_file.to_solr[Hydra.config[:permissions][:read][:group]]).to eq(['registered'])
        return_value.should be_true
      end
    end



    describe 'with a cloud file' do

      let(:attributes) {
        { cloud_resources: cloud_resource.resources_to_ingest, title: title, visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED }
      }
      it 'succeeds if attributes are given' do
        return_value = nil
        expect {
          return_value = subject.create
        }.to change {
          parent.class.find(parent.pid).generic_files.count
        }.by(1)

        reloaded_generic_file.batch.should == parent
        reloaded_generic_file.to_s.should == title
        reloaded_generic_file.filename.should == File.basename(__FILE__)

        expect(reloaded_generic_file.to_solr[Hydra.config[:permissions][:read][:group]]).to eq(['registered'])
        return_value.should be_true
      end
    end

    it 'failure returns false' do
      CurationConcern::BaseActor.any_instance.should_receive(:save).and_return(false)
      subject.stub(:update_file).and_return(true)
      subject.create.should be_false
    end
  end

  describe '#update' do
    let(:generic_file) {
      FactoryGirl.create_generic_file(parent, user)
    }

    describe 'with a file' do
      it 'succeeds if attributes are given' do
      generic_file.title.should_not == title
      generic_file.content.content.should_not == file_content
      return_value = nil
      return_value = subject.update
      generic_file.title.should == [title]
      generic_file.to_s.should == title
      generic_file.content.content.should == file_content
      return_value.should be_true
      end
    end

    describe 'with a cloud file' do
      let(:attributes) {
        { cloud_resources: cloud_resource.resources_to_ingest, title: title, visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED }
      }
      it 'succeeds if attributes are given' do
        generic_file.title.should_not == title
        generic_file.content.content.should_not == file_content
        return_value = nil
        return_value = subject.update
        generic_file.title.should == [title]
        generic_file.to_s.should == title
        generic_file.content.content.should == file_content
        return_value.should be_true
      end
    end

    it 'failure returns false' do
      CurationConcern::BaseActor.any_instance.should_receive(:save).and_return(false)
      subject.update.should be_false
    end
  end

  describe '#rollback' do
    let(:attributes) {
      { version: version }
    }
    let(:version) { generic_file.versions.last.version_id }
    let(:generic_file) { FactoryGirl.create_generic_file(parent, user, file) }
    let(:file) { Rack::Test::UploadedFile.new(__FILE__, 'text/plain', false) }
    let(:new_file) { curate_fixture_file_upload('files/image.png', 'image/png', false)}
    before(:each) do
      # I need to make an update
      updated_attributes = { file: new_file}
      actor = CurationConcern::GenericFileActor.new(generic_file, user, updated_attributes)
      actor.update
    end
    it do
      return_value = nil
      expect {
        return_value = subject.rollback
      }.to change {subject.curation_concern.content.mimeType}.from('image/png').to(mime_type)
      return_value.should be_true
    end

    it 'failure returns false' do
      generic_file.should_receive(:save).and_return(false)
      subject.rollback.should be_false
    end
  end
end


