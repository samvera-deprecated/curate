require 'spec_helper'

describe CurationConcern::GenericFilesController do
  render_views
  let(:user) { FactoryGirl.create(:user) }
  let(:generic_file) { FactoryGirl.create_generic_file(:senior_thesis, user) }
  describe '#edit' do
    it 'should be successful' do
      generic_file
      sign_in user
      get :edit, id: generic_file.pid
      controller.curation_concern.should be_kind_of(GenericFile)
      response.should be_successful
    end
  end

  describe '#show' do
    it 'should be successful' do
      generic_file
      sign_in user
      get :show, id: generic_file.pid
      controller.curation_concern.should be_kind_of(GenericFile)
      response.should be_successful
    end
  end

  def create_generic_file
  end
end
