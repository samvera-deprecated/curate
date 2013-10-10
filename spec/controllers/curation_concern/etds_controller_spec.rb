require 'spec_helper'

describe CurationConcern::EtdsController do
  let(:person) { FactoryGirl.create(:person_with_user) }
  let(:user) { person.user }
  before { sign_in user }

  describe "#show" do
    context "my own private work" do
      let(:etd) { FactoryGirl.create(:private_etd, person: person) }
      it "should show me the page" do
        get :show, id: etd
        expect(response).to be_success
      end
    end
    context "someone elses private work" do
      let(:etd) { FactoryGirl.create(:private_etd) }
      it "should show 401 Unauthorized" do
        get :show, id: etd
        expect(response.status).to eq 401
        response.should render_template(:unauthorized)
      end
    end
    context "someone elses public work" do
      let(:etd) { FactoryGirl.create(:public_etd) }
      it "should show me the page" do
        get :show, id: etd
        expect(response).to be_success
      end
    end
  end

  describe "#create" do
    it "should create a work" do
      controller.curation_concern.stub(:persisted?).and_return(true)
      controller.actor = double(:create => true)
      post :create, accept_contributor_agreement: "accept"
      response.should redirect_to curation_concern_etd_path(controller.curation_concern)
    end
  end

  describe "#update" do
    let(:etd) { FactoryGirl.create(:etd, person: person) }
    it "should update the work " do
      controller.actor = double(:update => true, :visibility_changed? => false)
      patch :update, id: etd
      response.should redirect_to curation_concern_etd_path(controller.curation_concern)
    end
    describe "changing rights" do
      it "should prompt to change the files access" do
        controller.actor = double(:update => true, :visibility_changed? => true)
        patch :update, id: etd
        response.should redirect_to confirm_curation_concern_permission_path(controller.curation_concern)
      end
    end
  end
end
