require 'spec_helper'

describe "Collections show view: " do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:bilbo) { FactoryGirl.create(:person, name: 'Bilbo') }
  let!(:frodo) { FactoryGirl.create(:person, name: 'Frodo') }
  let!(:article) { FactoryGirl.create(:generic_work, user: user, contributors: [bilbo, frodo], title: 'An Article') }
  let!(:collection) { FactoryGirl.create(:public_collection, user: user, title: 'Collected Stuff', members: [article]) }

  context "For logged in members:" do
    it "remove an item from the collection" do
      login_as(user)
      visit collection_path(collection.pid)
      page.should have_css(".collection-member[data-noid='#{article.noid}']")
      click_on "remove-#{article.noid}"

      visit collection_path(collection.pid)
      page.should_not have_css(".collection-member[data-noid='#{article.noid}']")
    end

    it "should display the delete button" do
      collection.save!
      login_as(user)
      visit collection_path(collection.pid)
      expect(page).to have_button('Delete')
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

