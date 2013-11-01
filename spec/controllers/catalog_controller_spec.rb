require 'spec_helper'

describe CatalogController do

  describe "when logged in" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:work1) { FactoryGirl.create(:generic_work, user: user) }
    let!(:work2) { FactoryGirl.create(:generic_work) }
    before do
      sign_in user
    end
    after do
      work1.destroy
      work2.destroy
    end
    context "Searching all works" do
      it "should return all the works" do
        get 'index', 'f' => {'generic_type_sim' => 'Work'}
        response.should be_successful
        ids = assigns(:document_list).map(&:id)
        expect(ids).to include(work1.id)
        expect(ids).to include(work2.id)
      end
    end

    context "searching just my works" do
      it "should return just my works" do
        get 'index', works: 'mine'
        response.should be_successful
        ids = assigns(:document_list).map(&:id)
        expect(ids).to include(work1.id)
        expect(ids).to_not include(work2.id)
      end
    end

    context "index page" do
      let!(:collection) { FactoryGirl.create(:collection, user: user) }
      after do
        collection.destroy
      end

      it "assigns options for adding items to collection" do
        get 'index'
        expect(assigns(:collection_options)).to include(collection)
        expect(assigns(:profile_collection_options)).to_not include(collection)
      end
    end

    context "when json is requested for autosuggest of related works" do
      let!(:work) { FactoryGirl.create(:generic_work, user: user, title:"All my #{srand}") }
      after do
        work.destroy
      end
      it "should return json" do
        xhr :get, :index, format: :json, q: work.title
        json = JSON.parse(response.body)

        expect(json["docs"]).to include({"pid"=>work.pid, "title"=>work.title})
      end
    end

  end
end
