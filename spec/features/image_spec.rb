require 'spec_helper'

describe 'Creating an image' do
  let(:user) { FactoryGirl.create(:user) }

  it "should allow me to attach the link on the create page" do
    login_as(user)
    visit root_path
    click_link "add-content"
    classify_what_you_are_uploading 'Image'
    within '#new_image' do
      fill_in "Title", with: "readymade shabby chic paleo ethical"
      fill_in "Creator", with: "Test image creator"
      fill_in "Date created", with: "2013-10-04"
      fill_in "Description", with: "Test description"
      select(Sufia.config.cc_licenses.keys.first.dup, from: I18n.translate('sufia.field_label.rights'))
      check("I have read and accept the contributor license agreement")
      click_button("Create Image")
    end

    # then I should find it in the search results.
    fill_in 'Search Curate', with: 'readymade paleo'
    click_button 'keyword-search-submit'
    within('#documents') do
      expect(page).to have_link('readymade shabby chic paleo ethical') #title
      expect(page).to have_selector('dd', text: '2013-10-04')
      expect(page).to have_selector('dd', text: 'Test image creator')
    end
  end
end

describe 'Viewing an image that is private' do
  let(:user) { FactoryGirl.create(:user) }
  let(:work) { FactoryGirl.create(:private_image, title: "Sample work" ) }

  it 'should show a stub indicating we have the work, but it is private' do
    login_as(user)
    visit curation_concern_image_path(work)
    page.should have_content('Unauthorized')
    page.should have_content('The image you have tried to access is private')
    page.should have_content("ID: #{work.pid}")
    page.should_not have_content("Sample work")
  end
end



