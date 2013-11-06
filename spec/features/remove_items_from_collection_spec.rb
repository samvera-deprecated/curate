require 'spec_helper'

describe "Remove member from collection" do
  let(:user) { FactoryGirl.create(:user) }
  let(:article) { FactoryGirl.create(:generic_work, user: user, title: 'A Scholarly Paper') }
  let(:collection) { FactoryGirl.create(:public_collection, user: user, title: 'Articles of Great Import', members: [article]) }

  context "If a user alredy has a collection with content in it" do
    it "should be easy to remove a member from a collection" do
      login_as(user)
      visit collection_path(collection)
      page.should have_css("[data-noid='#{article.noid}']")
      click_on "remove-#{article.noid}"

      visit curation_concern_generic_work_path(article.noid)
      page.should_not have_css("[data-noid='#{collection.noid}']")
    end
  end
end
