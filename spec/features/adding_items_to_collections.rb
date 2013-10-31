require 'spec_helper'

describe "Adding items to collections: " do
  let(:user) { FactoryGirl.create(:user) }
  let!(:collection) { FactoryGirl.create(:public_collection, user: user, title: 'Collected Stuff') }
  let!(:work1) { FactoryGirl.create(:generic_work, user: user, title: 'Work 1') }
  let!(:work2) { FactoryGirl.create(:generic_work, user: user, title: 'Work 2') }

  before do
    login_as(user)
  end

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
