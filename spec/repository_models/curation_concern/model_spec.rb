require 'spec_helper'

describe CurationConcern::Model do
  context 'index_collection_pids' do
    let(:work){FactoryGirl.create(:generic_work, title: 'Work') }
    let(:reloaded_work) { GenericWork.find(work.pid) }

    let(:collection){ FactoryGirl.create(:collection) }
    let(:reloaded_collection) { Collection.find(collection.pid) }

    let(:user) { FactoryGirl.create(:person_with_user) }
    let(:profile) { user.profile }
    let(:reloaded_profile){ Profile.find(profile.pid) }

    it 'should only index collection and not profile and profile sections' do
      collection.add_member(work)
      profile.add_member(work)

      reloaded_collection.members.should == [work]  
      reloaded_profile.members.should == [work]  
      reloaded_work.to_solr["collection_sim"].should == [collection.pid]
      reloaded_work.to_solr["collection_sim"].should_not == [profile.pid]
    end
  end
end
