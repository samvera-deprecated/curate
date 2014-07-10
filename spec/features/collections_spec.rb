require 'spec_helper'

describe "Showing and creating Collections" do
  let(:user) { FactoryGirl.create(:user) }

  it "should create them" do
    login_as(user)
    visit root_path
    click_link "Add a Collection"
    expect(page).to have_content "Create a New Collection"
    fill_in 'collection_title', with: 'amalgamate members'
    fill_in 'collection_description', with: "I've collected a few related things together"
    expect(page).to have_content "Access Rights"
    click_button "Create Collection"
    within '.search-result' do
      expect(page).to have_content 'amalgamate members'
    end

    # then I should find it in the search results.
    fill_in 'Search Curate', with: 'amalgamate members'
    click_button 'keyword-search-submit'
    within('#documents') do
      expect(page).to have_link('amalgamate members') #title
      expect(page).to have_selector('dd', text: "I've collected a few related things together")
      expect(page).to have_selector('dd', text: user.email)
    end
  end

  it "should accept and display an optional image" do
    login_as(user)
    visit root_path
    click_link "Add a Collection"
    fill_in 'collection_title', with: 'amalgamate members'
    fill_in 'collection_description', with: "I've collected a few related things together"
    attach_file( 'collection_file', Rails.root.join('../fixtures/files/image.png') )
    click_button "Create Collection"
    expect( page ).to have_css( "img[src$='/downloads/#{user.collections.first.pid}?datastream_id=thumbnail']" )

    visit collection_path( user.collections.first )
    expect( page ).to have_css( "img[src$='/downloads/#{user.collections.first.pid}?datastream_id=thumbnail']" )

    visit edit_collection_path( user.collections.first )
    expect( page ).to have_css( "img[src$='/downloads/#{user.collections.first.pid}?datastream_id=thumbnail']" )

    visit root_path
    expect( page ).to have_css( "img[src$='/downloads/#{user.collections.first.pid}?datastream_id=thumbnail']" )
  end

  it 'displays a friendly message if user has no collections yet' do
    login_as(user)
    visit collections_path

    msg = 'No items found'
    expect(page).to have_content(msg)
  end
end

describe 'Viewing a collection that is private' do
  let(:user) { FactoryGirl.create(:user) }
  let(:collections) { FactoryGirl.create(:private_collection, title: "Sample collection" ) }

  it 'should show a stub indicating we have the work, but it is private' do
    login_as(user)
    visit collection_path(collection)
    page.should have_content('Unauthorized')
    page.should have_content('The collection you have tried to access is private')
    page.should have_content("ID: #{collection.pid}")
    page.should_not have_content("Sample collection")
  end
end

