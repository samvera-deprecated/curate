require 'spec_helper'

describe CurationConcern::GenericWorksController do
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }
      
  describe "#create" do
    it "should create a linked resource" do
      post :create, accept_contributor_agreement: "accept", generic_work: {
        title: "A title", linked_resource_url: "http://www.youtube.com/watch?v=oHg5SJYRHA0",
        rights: "http://creativecommons.org/licenses/by/3.0/us/"
      }
      response.should redirect_to curation_concern_generic_work_path(assigns[:curation_concern])
      expect(assigns[:curation_concern].linked_resources.size).to eq 1
      expect(assigns[:curation_concern].linked_resources.first.url).to eq "http://www.youtube.com/watch?v=oHg5SJYRHA0"
    end
  end

  describe "#update" do
    let!(:collection1) { FactoryGirl.create(:collection, user: user) }
    let!(:collection2) { FactoryGirl.create(:collection, user: user) }
    let!(:generic_work) { FactoryGirl.create(:generic_work, user: user) }
    before do
      collection1.members << generic_work
      collection1.save
    end
    it "should add to a collection" do
      generic_work.reload
      generic_work.collections.should == [collection1]
      patch :update, generic_work: { "collection_ids"=>[collection2.pid]}, id: generic_work
      response.should redirect_to curation_concern_generic_work_path(assigns[:curation_concern])
      generic_work.reload
      expect(generic_work.collections).to eq [collection2]
    end
  end
end
