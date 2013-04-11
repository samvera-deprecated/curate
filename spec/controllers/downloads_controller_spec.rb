require 'spec_helper'

describe DownloadsController do
  describe '#show' do
    let(:user) { FactoryGirl.create(:user) }
    let(:another_user) { FactoryGirl.create(:user) }
    let(:visibility) { AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE }
    let(:generic_file) {
      FactoryGirl.create_generic_file(:mock_curation_concern, user) {|g|
        g.visibility = visibility
      }
    }

    it "raise not_found if the object does not exist" do
      expect {
        get :show, id: '8675309'
      }.to raise_rescue_response_type(:not_found)
    end

    it "responds :unauthorized if user doesn't have access" do
      generic_file
      sign_in another_user
      expect {
        get :show, id: generic_file.to_param
      }.to raise_rescue_response_type(:unauthorized)
    end

    it "responds :unauthorized if you aren't logged in" do
      generic_file
      expect {
        get :show, id: generic_file.to_param
      }.to raise_rescue_response_type(:unauthorized)
    end

    it 'sends the file if the user has access' do
      generic_file
      sign_in user
      get :show, id: generic_file.to_param
      response.body.should == generic_file.content.content
    end
  end
end
