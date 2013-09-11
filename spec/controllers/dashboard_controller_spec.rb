require 'spec_helper'

describe DashboardController do
  before do
    GenericFile.any_instance.stub(:terms_of_service).and_return('1')
    User.any_instance.stub(:groups).and_return([])
    controller.stub(:clear_session_user) ## Don't clear out the authenticated session
  end
  describe "logged in user" do
    let(:user) { FactoryGirl.create(:user) }
    before (:each) do
      sign_in user
      controller.stub(:clear_session_user) ## Don't clear out the authenticated session
      User.any_instance.stub(:groups).and_return([])
    end
    describe "#index" do
      it "should be a success" do
        xhr :get, :index
        response.should be_success
        response.should render_template('dashboard/index')
      end
      it "should return an array of documents I can edit" do
        xhr :get, :index
        user.profile.delete   # Don't include the user's auto-generated profile
        @user_results = Blacklight.solr.get "select", :params=>{:fq=>["edit_access_group_ssim:public OR edit_access_person_ssim:#{user.user_key}"]}
        assigns(:document_list).count.should eql(@user_results["response"]["numFound"])
      end
      it "should return json" do
        work = FactoryGirl.create(:generic_work, user: user, title:"All my #{srand}")
        work.save
        xhr :get, :index, format: :json, q: work.title
        json = JSON.parse(response.body)
        # Should repeat the solr responseHeader
        json["responseHeader"].keys.should == ["status", "QTime", "params"]
        # Grab the doc corresponding to work and inspect the json
        work_json = json["docs"].first
        work_solr_doc = work_json.delete("solr_doc")  # removing the solr_doc because its hard to run a clean comparison
        work_json.should == {"pid"=>work.pid, "title"=>work.title, "model"=>"GenericWork", "curation_concern_type"=>"Generic Work"}
        # Trying to check the contents of work_solr_doc
        # work_solr_doc.keys.to_set.should == work.to_solr.with_indifferent_access.keys.to_set
        work_solr_doc.should be_instance_of(Hash)
        work_solr_doc["id"].should == work.pid
      end
    end
  end
  describe "not logged in as a user" do
    describe "#index" do
      it "should return an error" do
        xhr :get, :index
        response.should_not be_success
      end
    end
  end
end
