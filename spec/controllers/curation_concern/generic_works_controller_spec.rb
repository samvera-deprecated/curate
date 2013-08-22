require 'spec_helper'

describe CurationConcern::GenericWorksController do
  describe "#create" do
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }
      
    it "should create a linked resource" do
      post :create, accept_contributor_agreement: "accept", generic_work: {
        title: "A title", linked_resource_url: "http://www.youtube.com/watch?v=oHg5SJYRHA0",
        rights: "http://creativecommons.org/licenses/by/3.0/us/"
      }
      response.should redirect_to curation_concern_generic_work_path(assigns[:curation_concern])
      assigns[:curation_concern].linked_resources.size.should == 1
      assigns[:curation_concern].linked_resources.first.url.should == "http://www.youtube.com/watch?v=oHg5SJYRHA0"
    end
  end
end
