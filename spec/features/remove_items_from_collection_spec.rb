require 'spec_helper'

describe "GenericWork show view: " do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:work1) { FactoryGirl.create(:generic_work, user: user, title: 'Work 1') }
  let!(:collection) { FactoryGirl.create(:public_collection, user: user, title: 'Collected Stuff', members: [work1]) }

  context "For logged in members: " do
    it "remove this item from the collection" do
      collection.members << work1
      collection.save!
      login_as(user)
      visit curation_concern_generic_work_path(work1.pid)
      page.should have_css("a[href$='/collections/#{collection.pid}']")
      click_on 'Remove Item from Collection'

      visit curation_concern_generic_work_path(work1.pid)
      page.should_not have_css("a[href$='/collections/#{collection.pid}']")
      page.should_not have_css("a[title$='Remove Item from Collection']")
    end
  end
end
