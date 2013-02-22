require 'spec_helper'

describe CurationConcern::GenericFilesController do
  render_views
  let(:user) { FactoryGirl.create(:user) }
  let(:generic_file) { GenericFile.new }
  let(:file) { Rack::Test::UploadedFile.new(__FILE__, 'text/plain', false)}
  let(:batch_id) { CurationConcern.mint_a_pid }
  describe '#edit' do
    it 'should be successful' do
      create_generic_file
      sign_in user
      get :edit, id: generic_file.pid
      controller.curation_concern.should be_kind_of(GenericFile)
      response.should be_successful
    end
  end

  describe '#show' do
    it 'should be successful' do
      create_generic_file
      sign_in user
      get :show, id: generic_file.pid
      controller.curation_concern.should be_kind_of(GenericFile)
      response.should be_successful
    end
  end

  def create_generic_file
    Sufia::GenericFile::Actions.create_metadata(generic_file, user, batch_id)
    Sufia::GenericFile::Actions.create_content(
      generic_file,
      file,
      file.original_filename,
      'content',
      user
    )
  end
end
