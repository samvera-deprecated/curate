require 'spec_helper'

describe 'Creating a dataset' do
  let(:user) { FactoryGirl.create(:user) }

  describe 'with a related link' do
    it "should allow me to attach the link on the create page" do
      login_as(user)
      visit root_path
      click_link "Get Started"
      click_link "Submit a work"
      classify_what_you_are_uploading 'Dataset'
      within '#new_dataset' do
        fill_in "Title", with: "My title"
        fill_in "External link", with: "http://www.youtube.com/watch?v=oHg5SJYRHA0"
        select(Sufia.config.cc_licenses.keys.first, from: I18n.translate('sufia.field_label.rights'))
        check("I have read and accept the contributor licence agreement")
        click_button("Create Dataset")
      end
      expect(page).to have_selector('h1', text: 'Dataset')
      within ('.linked_resource.attributes') do
        expect(page).to have_link('http://www.youtube.com/watch?v=oHg5SJYRHA0', href: 'http://www.youtube.com/watch?v=oHg5SJYRHA0')
      end
    end
  end
end

describe 'An existing dataset' do
  let(:user) { FactoryGirl.create(:user) }
  let(:dataset) { FactoryGirl.create(:dataset, user: user) }
  let(:you_tube_link) { 'http://www.youtube.com/watch?v=oHg5SJYRHA0' }

  it 'should allow me to attach a linked resource' do
    login_as(user)
    visit curation_concern_dataset_path(dataset)
    click_link 'Add an External Link'

    within '#new_linked_resource' do
      fill_in 'External link', with: you_tube_link
      click_button 'Add External Link'
    end

    within ('.linked_resource.attributes') do
      expect(page).to have_link(you_tube_link, href: you_tube_link)
    end
  end

  it 'cancel takes me back to the dashboard' do
    login_as(user)
    visit curation_concern_dataset_path(dataset)
    click_link 'Add an External Link'
    page.should have_link('Cancel', href: dashboard_index_path)
  end
end

