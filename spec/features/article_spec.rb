require 'spec_helper'

describe 'Creating a article' do
  let(:user) { FactoryGirl.create(:user) }

  describe 'with a related link' do
    it "should allow me to attach the link on the create page" do
      login_as(user)
      visit root_path
      click_link "add-content"
      classify_what_you_are_uploading 'Article'
      within '#new_article' do
        fill_in "Title", with: "craft beer roof party YOLO fashion axe"
        fill_in "Abstract", with: "My abstract"
        fill_in "Contributor", with: "Test article contributor"
        fill_in "External link", with: "http://www.youtube.com/watch?v=oHg5SJYRHA0"
        select(Sufia.config.cc_licenses.keys.first.dup, from: I18n.translate('sufia.field_label.rights'))
        check("I have read and accept the contributor license agreement")
        click_button("Create Article")
      end
      expect(page).to have_selector('h1', text: 'Article')
      within ('.linked_resource.attributes') do
        expect(page).to have_link('http://www.youtube.com/watch?v=oHg5SJYRHA0', href: 'http://www.youtube.com/watch?v=oHg5SJYRHA0')
      end

      # then I should find it in the search results.
      fill_in 'Search Curate', with: 'roof party'
      click_button 'keyword-search-submit'
      within('#documents') do
        expect(page).to have_link('craft beer roof party YOLO fashion axe') #title
        expect(page).to have_selector('dd', text: 'My abstract')
        expect(page).to have_selector('dd', text: 'Test article contributor')
      end

    end
  end
end

describe 'An existing article owned by me' do
  let(:user) { FactoryGirl.create(:user) }
  let(:article) { FactoryGirl.create(:article, user: user) }
  let(:you_tube_link) { 'http://www.youtube.com/watch?v=oHg5SJYRHA0' }

  it 'should allow me to attach a linked resource' do
    login_as(user)
    visit curation_concern_article_path(article)
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
    visit curation_concern_article_path(article)
    click_link 'Add an External Link'
    page.should have_link('Cancel', href: catalog_index_path)
  end
end

describe 'Viewing an Article that is private' do
  let(:user) { FactoryGirl.create(:user) }
  let(:work) { FactoryGirl.create(:private_article, title: "Sample work" ) }

  it 'should show a stub indicating we have the work, but it is private' do
    login_as(user)
    visit curation_concern_article_path(work)
    page.should have_content('Unauthorized')
    page.should have_content('The article you have tried to access is private')
    page.should have_content("ID: #{work.pid}")
    page.should_not have_content("Sample work")
  end
end

