require 'spec_helper'

describe CurationConcern::GenericFilesController do
  render_views
  let(:user) { FactoryGirl.create(:user) }
  let(:generic_file) { FactoryGirl.create_generic_file(:senior_thesis, user) }
  let(:another_user) { FactoryGirl.create(:user) }
  describe '#edit' do
    it 'should be successful' do
      generic_file
      sign_in user
      get :edit, id: generic_file.to_param
      controller.curation_concern.should be_kind_of(GenericFile)
      response.should be_successful
    end
  end

  describe '#show' do
    it 'should be successful' do
      generic_file
      sign_in user
      get :show, id: generic_file.to_param
      controller.curation_concern.should be_kind_of(GenericFile)
      response.should be_successful
    end

    it 'does not allow another user to view it' do
      generic_file
      sign_in another_user
      get :show, id: generic_file.to_param
      response.status.should == 302
      expect(response).to redirect_to(root_url)
    end
  end

end
