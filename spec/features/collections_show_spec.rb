require 'spec_helper'

describe "Collections show view: " do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:bilbo) { FactoryGirl.create(:person, name: 'Bilbo') }
  let!(:frodo) { FactoryGirl.create(:person, name: 'Frodo') }
  let!(:work1) { FactoryGirl.create(:generic_work, user: user, contributors: [bilbo, frodo], title: 'Work 1') }
  let!(:collection) { FactoryGirl.create(:public_collection, user: user, title: 'Collected Stuff', members: [work1]) }

  context "For logged in members: " do
    it "remove an item from the collection" do
      login_as(user)
      visit collection_path(collection.pid)
      page.should have_css("a[id$='#{work1.pid}']")
      page.should have_css("a[title$='Remove Item from Collection']")
      click_on 'Remove Item from Collection'

      visit collection_path(collection.pid)
      page.should_not have_css("a[id$='#{work1.pid}']")
      page.should_not have_css("a[title$='Remove Item from Collection']")
    end
  end

  context "In public view: " do
    it "should not display remove_member link" do
      Capybara.reset_sessions!
      visit destroy_user_session_url
      visit collection_path(collection.pid)
      page.should_not have_css("a[title$='Remove Item from Collection']")
    end
  end

  context "Contributors:" do
    it "should be displayed in each line items" do
      visit collection_path(collection.pid)
      page.should have_content('Frodo')
      page.should have_content('Bilbo')
    end
  end
end
