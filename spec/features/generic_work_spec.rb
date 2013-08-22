require 'spec_helper'

describe 'Creating a generic work' do
  let(:user) { FactoryGirl.create( :user) }

  describe 'with a related link' do
    it "should allow me to attach the link on the create page" do
      login_as(user)
      visit root_path
      click_link "Get Started"
      click_link "Submit a work"
      classify_what_you_are_uploading 'Generic Work' 
      within '#new_generic_work' do
        fill_in "Title", with: "My title"
        fill_in "External link", with: "http://www.youtube.com/watch?v=oHg5SJYRHA0"
        select(Sufia.config.cc_licenses.keys.first, from: I18n.translate('sufia.field_label.rights'))
        check("I have read and accept the contributor licence agreement")
        click_button("Create Generic work")
      end
      
      expect(page).to have_selector('h1', text: 'Generic Work')
      within ('.linked_resource.attributes') do
        expect(page).to have_link('http://www.youtube.com/watch?v=oHg5SJYRHA0', href: 'http://www.youtube.com/watch?v=oHg5SJYRHA0')
      end
    end
  end
end
