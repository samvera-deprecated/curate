require 'spec_helper'

describe CurationConcern::DatasetsController do
  include_examples 'is_a_curation_concern_controller', Dataset
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "#show" do
    context "my own private work" do
      let(:dataset) { FactoryGirl.create(:private_dataset, user: user) }
      it "should show me the page" do
        get :show, id: dataset
        expect(response).to be_success
      end
    end
    context "someone elses private work" do
      let(:dataset) { FactoryGirl.create(:private_dataset) }
      it "should show 401 Unauthorized" do
        get :show, id: dataset
        expect(response.status).to eq 401
      end
    end
    context "someone elses public work" do
      let(:dataset) { FactoryGirl.create(:public_dataset, user: user) }
      it "should show me the page" do
        get :show, id: dataset
        expect(response).to be_success
      end
    end
  end

  describe "#create" do
    it "should create a work" do
      controller.curation_concern.stub(:persisted?).and_return(true)
      controller.actor = double(:create! => true)
      post :create, accept_contributor_agreement: "accept"
      response.should redirect_to curation_concern_dataset_path(controller.curation_concern)
    end
  end

  describe "#update" do
    let(:dataset) { FactoryGirl.create(:dataset, user: user) }
    it "should update the work " do
      controller.actor = double(:update! => true, :visibility_changed? => false)
      patch :update, id: dataset
      response.should redirect_to curation_concern_dataset_path(controller.curation_concern)
    end
    describe "changing rights" do
      it "should prompt to change the files access" do
        controller.actor = double(:update! => true, :visibility_changed? => true)
        patch :update, id: dataset
        response.should redirect_to confirm_curation_concern_permission_path(controller.curation_concern)
      end
    end
  end
end
