require 'spec_helper'

describe "Collections" do
  let(:user) { FactoryGirl.create(:user) }

  it "should create them" do
    login_as(user)
    visit root_path
    click_link "Get Started"
    within 'nav' do
      click_link "Collections"
    end
    click_button "Create Collection"
    expect(page).to have_content "Create New Collection"
    fill_in 'Title', with: 'amalgamate members'
    fill_in 'Description', with: "I've collected a few related things together"
    click_button "Create Collection"
    within 'table tbody' do
      expect(page).to have_content 'amalgamate members'
    end
  end

  it 'displays a friendly message if user has no collections yet' do
    login_as(user)
    Collection.delete_all  # Delete the user's auto-generated profile
    visit collections_path

    msg = 'You have no collections yet'
    expect(page).to have_content(msg)
    expect(page).to have_button('Create Collection')
  end
end
