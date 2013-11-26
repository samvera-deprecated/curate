require 'spec_helper'

describe 'Creating a generic work' do
  let(:user) { FactoryGirl.create(:user) }

  describe 'with a related link' do
    it "should allow me to attach the link on the create page" do
      login_as(user)
      visit root_path
      click_link "add-content"
      classify_what_you_are_uploading 'Generic Work'
      within '#new_generic_work' do
        fill_in "Title", with: "My title"
        fill_in "External link", with: "http://www.youtube.com/watch?v=oHg5SJYRHA0"
        select(Sufia.config.cc_licenses.keys.first.dup, from: I18n.translate('sufia.field_label.rights'))
        check("I have read and accept the contributor license agreement")
        click_button("Create Generic work")
      end

      expect(page).to have_selector('h1', text: 'Generic Work')
      within ('.linked_resource.attributes') do
        expect(page).to have_link('http://www.youtube.com/watch?v=oHg5SJYRHA0', href: 'http://www.youtube.com/watch?v=oHg5SJYRHA0')
      end
    end
  end
end

describe 'An existing generic work owned by the user' do
  let(:user) { FactoryGirl.create(:user) }
  let(:work) { FactoryGirl.create(:generic_work, user: user) }
  let(:you_tube_link) { 'http://www.youtube.com/watch?v=oHg5SJYRHA0' }

  it 'should allow me to attach a linked resource' do
    login_as(user)
    visit curation_concern_generic_work_path(work)
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
    visit curation_concern_generic_work_path(work)
    click_link 'Add an External Link'
    page.should have_link('Cancel', href: catalog_index_path)
  end
end

describe 'Viewing a generic work that is private' do
  let(:user) { FactoryGirl.create(:user) }
  let(:work) { FactoryGirl.create(:private_generic_work, title: "Sample work" ) }

  it 'should show a stub indicating we have the work, but it is private' do
    login_as(user)
    visit curation_concern_generic_work_path(work)
    page.should have_content('Unauthorized')
    page.should have_content('The generic work you have tried to access is private')
    page.should have_content("ID: #{work.pid}")
    page.should_not have_content("Sample work")
  end
end

describe 'When I click on the link to create a work: ' do
  let(:account) { FactoryGirl.create(:account, name: 'Iron Man') }
  let(:user) { account.user }
  let(:person) { account.person }
  before { login_as(user) }
  it 'should have my name set in the creator/contributor list' do
    visit new_curation_concern_generic_work_path
    page.should have_css("a[href$='people/#{person.to_param}']")
    page.should have_tag("a[href$='people/#{person.to_param}']", text: "Iron Man")
  end
end

