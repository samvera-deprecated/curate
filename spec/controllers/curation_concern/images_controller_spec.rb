require 'spec_helper'

describe CurationConcern::ImagesController do
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "#show" do
    context "my own private work" do
      let(:image) { FactoryGirl.create(:private_image, user: user) }
      it "should show me the page" do
        get :show, id: image
        expect(response).to be_success
      end
    end
    context "someone elses private work" do
      let(:image) { FactoryGirl.create(:private_image) }
      it "should show 401 Unauthorized" do
        get :show, id: image
        expect(response.status).to eq 401
        response.should render_template(:unauthorized)
      end
    end
    context "someone elses public work" do
      let(:image) { FactoryGirl.create(:public_image) }
      it "should show me the page" do
        get :show, id: image
        expect(response).to be_success
      end
    end
  end

  describe "#create" do
    it "should create a work" do
      controller.curation_concern.stub(:persisted?).and_return(true)
      controller.actor = double(:create! => true)
      post :create, accept_contributor_agreement: "accept"
      response.should redirect_to curation_concern_image_path(controller.curation_concern)
    end
  end

  describe "#update" do
    let(:image) { FactoryGirl.create(:image, user: user) }
    it "should update the work " do
      controller.actor = double(:update! => true, :visibility_changed? => false)
      patch :update, id: image
      response.should redirect_to curation_concern_image_path(controller.curation_concern)
    end
    describe "changing rights" do
      it "should prompt to change the files access" do
        controller.actor = double(:update! => true, :visibility_changed? => true)
        patch :update, id: image
        response.should redirect_to confirm_curation_concern_permission_path(controller.curation_concern)
      end
    end
  end
end
