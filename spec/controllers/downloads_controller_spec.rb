require 'spec_helper'

describe DownloadsController do
  describe '#show' do
    let(:user) { FactoryGirl.create(:user) }
    let(:another_user) { FactoryGirl.create(:user) }
    let(:generic_file) { FactoryGirl.create_generic_file(:senior_thesis, user) }

    it "renders a :not_found if the object does not exist" do
      get :show, id: '8675309'
      response.response_code.should == 404
    end

    it "responds :unauthorized if user doesn't have access" do
      generic_file
      sign_in another_user
      get :show, id: generic_file.to_param
      response.response_code.should == 401
    end

    it "responds :unauthorized if you aren't logged in" do
      generic_file
      get :show, id: generic_file.to_param
      response.response_code.should == 401
    end

    it 'sends the file if the user has access' do
      generic_file
      sign_in user
      get :show, id: generic_file.to_param
      response.body.should == generic_file.content.content
    end
  end
end
