require 'spec_helper'

describe CatalogController do

  describe "when logged in" do
    before :all do
      ActiveFedora::Base.destroy_all
    end
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
        assigns(:document_list).map(&:id).should == [work1.id, work2.id]
      end
    end

    context "searching just my works" do
      it "should return just my works" do
        get 'index', works: 'mine'
        response.should be_successful
        assigns(:document_list).map(&:id).should == [work1.id]
      end
    end

    context "index page" do
      let!(:collection) { FactoryGirl.create(:collection, user: user) }
      after do
        collection.destroy
      end

      it "assigns options for adding items to collection" do
        get 'index'
        assigns(:collection_options).should == [collection]
        assigns(:profile_collection_options).should == []
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
        # Grab the doc corresponding to work and inspect the json
        work_json = json["docs"].first
        work_json.should == {"pid"=>work.pid, "title"=> "#{work.title} (#{work.human_readable_type})"}
      end
    end

  end
end
