require 'spec_helper'

describe CurationConcern::GenericWorksController do
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "#show" do
    context "my own private work" do
      let(:generic_work) { FactoryGirl.create(:private_work, user: user) }
      it "should show me the page" do
        get :show, id: generic_work
        expect(response).to be_success
      end
    end
    context "someone elses private work" do
      let(:generic_work) { FactoryGirl.create(:private_work) }
      it "should show 401 Unauthorized" do
        get :show, id: generic_work
        expect(response.status).to eq 401
      end
    end
    context "someone elses public work" do
      let(:generic_work) { FactoryGirl.create(:public_work) }
      it "should show me the page" do
        get :show, id: generic_work
        expect(response).to be_success
      end
    end
  end
      
  describe "#create" do
    it "should create a work" do
      controller.curation_concern.stub(:persisted?).and_return(true)
      controller.actor = double(:create! => true)
      post :create, accept_contributor_agreement: "accept"
      response.should redirect_to curation_concern_generic_work_path(controller.curation_concern)
    end
  end

  describe "#update" do
    let(:generic_work) { FactoryGirl.create(:generic_work, user: user) }
    it "should update the work " do
      controller.actor = double(:update! => true, :visibility_changed? => false)
      patch :update, id: generic_work
      response.should redirect_to curation_concern_generic_work_path(controller.curation_concern)
    end
    describe "changing rights" do
      it "should prompt to change the files access" do
        controller.actor = double(:update! => true, :visibility_changed? => true)
        patch :update, id: generic_work
        response.should redirect_to confirm_curation_concern_permission_path(controller.curation_concern)
      end
    end
  end
end
