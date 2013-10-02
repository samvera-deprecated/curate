require 'spec_helper'

describe Curate::CollectionsController do
  before(:all) { Collection.destroy_all }
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "#index" do
    let(:another_user) { FactoryGirl.create(:user) }
    let!(:collection) { FactoryGirl.create(:collection, user: user) }
    let!(:another_collection) { FactoryGirl.create(:collection, user: another_user) }
    let!(:public_collection) { FactoryGirl.create(:public_collection)}
    let!(:generic_work) { FactoryGirl.create(:generic_work, user: user) }
    it "should show a list of my collections" do
      get :index
      expect(response).to be_successful
      expect(assigns[:document_list].map(&:id)).to include collection.pid
      expect(assigns[:document_list].map(&:id)).to_not include another_collection.pid
      expect(assigns[:document_list].map(&:id)).to_not include public_collection.pid
      expect(assigns[:document_list].map(&:id)).to_not include generic_work.pid
    end
  end

  describe "#create" do
    it "should be successful" do
      expect {
        post :create, collection:  { title: 'test title', description: 'test desc'}
      }.to change{Collection.count}.by(1)
      expect(response).to redirect_to collections_path
      expect(flash[:notice]).to eq 'Collection was successfully created.'
    end
  end

  describe "without access" do
    describe "#update" do
      let(:collection) { FactoryGirl.create(:collection) }
      it "should be able to update permissions" do
        patch :update, id: collection.id, visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq 'You are not authorized to access this page.'

        collection.reload.should_not be_open_access

      end
    end
  end

  describe "with access" do
    describe "#update" do
      let(:collection) { FactoryGirl.create(:collection, user: user) }
      it "should be able to update permissions" do
        patch :update, id: collection.id, collection: {visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC}
        expect(response).to redirect_to collection_path(collection)
        expect(flash[:notice]).to eq 'Collection was successfully updated.'

        collection.reload.should be_open_access

      end
    end
  end

end
