require 'spec_helper'

describe Curate::CollectionsController do
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "#new" do
    it 'renders the form' do
      get :new
      expect(response).to render_template('new')
    end

    it 'passes the add_to_profile param' do
      get :new, add_to_profile: 'true'
      assigns(:add_to_profile).should == 'true'
      expect(response).to render_template('new')
    end
  end

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

  describe "#create with option to add to profile" do
    let(:reloaded_profile) { Collection.find(user.profile.pid) }
    it "adds the new collection to the user's profile" do
      account = FactoryGirl.create(:account, user: user)
      user.profile.members.should == []

      expect {
        expect {
          post :create, collection:  { title: 'test title', description: 'test desc'}, add_to_profile: 'true'
        }.to change{ProfileSection.count}.by(1)
      }.to_not change{Collection.count}

      reloaded_profile.members.should == [assigns(:collection)]
    end

    it "gracefully recovery if no profile exists" do
      user.profile.should be_nil
      expect {
        expect {
          post :create, collection:  { title: 'test title', description: 'test desc'}, add_to_profile: 'true'
        }.to change{ProfileSection.count}.by(1)
      }.to_not change{Collection.count}
      expect(response).to redirect_to user_profile_path
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

  describe "Adding an item to a collection: " do
    let!(:work) { FactoryGirl.create(:generic_work, user: user) }
    let!(:collection) { FactoryGirl.create(:collection, user: user) }

    describe "#add_member_form" do
      it "displays the form for adding an item to a collection" do
        get :add_member_form, collectible_id: work.pid
        assigns(:collectible).should == work
        assigns(:collection_options).should == [collection]
        expect(response).to render_template('add_member_form')
      end
    end

    describe "#add_member_form without read rights" do
      it "denies access" do
        another_user = FactoryGirl.create(:user)
        another_work = FactoryGirl.create(:private_generic_work, user: another_user)
        get :add_member_form, collectible_id: another_work.pid
        expect(response).to render_template('unauthorized')
      end
    end

    describe "#add_member" do
      it "adds the item to the collection" do
        put :add_member, collectible_id: work.pid, collection_id: collection.pid
        assigns(:collectible).should == work
        assigns(:collection).should == collection
        reload = Collection.find(collection.pid)
        reload.members.should == [work]
        expect(response).to redirect_to(catalog_index_path)
      end
    end

    describe "#add_member without edit rights" do
      it "denies access" do
        another_user = FactoryGirl.create(:user)
        another_collection = FactoryGirl.create(:public_collection, user: another_user)

        put :add_member, collectible_id: work.pid, collection_id: another_collection.pid

        assigns(:collectible).should == work
        assigns(:collection).should == another_collection
        reload = Collection.find(another_collection.pid)
        reload.members.should == []
        expect(response).to redirect_to(root_url)
      end
    end

    describe "#add_member failure" do
      it "prints fail message" do
        ActiveFedora::Base.stub(:find).and_call_original # Need to do this for cleanup
        ActiveFedora::Base.stub(:find).with(collection.pid, anything).and_return(collection)
        ActiveFedora::Base.stub(:find).with(work.pid, anything).and_return(work)

        collection.stub(:save).and_return(false)

        put :add_member, collectible_id: work.pid, collection_id: collection.pid
        expect(flash[:error]).to eq 'Unable to add item to collection.'
        expect(response).to redirect_to(catalog_index_path)
      end
    end

    describe "#add_member with invalid collection" do
      it "prints fail message" do
        put :add_member, collectible_id: work.pid, collection_id: ''
        expect(flash[:error]).to eq 'Unable to add item to collection.'
        expect(response).to redirect_to(catalog_index_path)
      end
    end
  end

end
