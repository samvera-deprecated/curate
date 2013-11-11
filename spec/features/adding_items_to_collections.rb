require 'spec_helper'

describe "Collections: " do
  let(:user) { FactoryGirl.create(:user) }

  before do
    login_as(user)
  end

  describe "Adding items to collections: " do
    let!(:collection) { FactoryGirl.create(:public_collection, user: user, title: 'Collected Stuff') }
    let!(:work1) { FactoryGirl.create(:generic_work, user: user, title: 'Work 1') }
    let!(:work2) { FactoryGirl.create(:generic_work, user: user, title: 'Work 2') }

    it "add an item from the catalog page" do
      work1.collections.should == []
      visit catalog_index_path
      within "#document_#{work1.noid}" do
        click_on 'Add to Collection'
      end
      within "#main form" do
        select('Collected Stuff')
        click_on 'Add'
      end
      reload = GenericWork.find(work1.pid)
      reload.collections.should == [collection]
    end

    it "add an item from item show page" do
      work2.collections.should == []
      visit curation_concern_generic_work_path(work2)
      click_link 'Add to Collection'
      within "#main form" do
        select('Collected Stuff')
        click_on 'Add'
      end

      reload = GenericWork.find(work2.pid)
      reload.collections.should == [collection]
    end
  end

  describe "A collection should not be added to itself" do
    let!(:collection1) { FactoryGirl.create(:public_collection, user: user, title: 'Colleciton 1') }
    let!(:collection2) { FactoryGirl.create(:public_collection, user: user, title: 'Collection 2') }
    it "should not display itself in the dropdown menu" do
      visit catalog_index_path
      within "#document_#{collection1.noid}" do
        click_on 'Add to Collection'
      end
      page.should_not have_xpath "//select[@id = 'collection_id']/option[@value = '" + collection1.pid + "']" 
      page.should have_xpath "//select[@id = 'collection_id']/option[@value = '" + collection2.pid + "']" 

      visit catalog_index_path
      within "#document_#{collection2.noid}" do
        click_on 'Add to Collection'
      end
      page.should have_xpath "//select[@id = 'collection_id']/option[@value = '" + collection1.pid + "']" 
      page.should_not have_xpath "//select[@id = 'collection_id']/option[@value = '" + collection2.pid + "']" 
    end
  end
end
