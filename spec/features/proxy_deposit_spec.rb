require 'spec_helper'

describe 'Proxy Deposit' do
  let(:user) { FactoryGirl.create(:user, name: 'Im A. User') }
  let(:proxy) { FactoryGirl.create(:user, name: 'Me A. Proxy') }
  let(:user_person) { FactoryGirl.create(:account, user: user)}
  let(:proxy_person) { FactoryGirl.create(:account, user: proxy)}
  before do
    user.can_receive_deposits_from << proxy
  end

  it 'defaults to blank for owner, with Myself and user name' do
    login_as(proxy)
    visit root_path
    click_link "add-content"
    classify_what_you_are_uploading 'Article'

    within '#new_article' do
      expect(page).to have_selector('#article_owner', text: "")
      expect(page).to have_selector('#article_owner', text: "Myself")
      expect(page).to have_selector('#article_owner', text: user.name)
      expect(page).to have_selector("input[id$=_creator]", text: "")
    end
  end

  it 'auto-selects user as contributor when user is selected as owner' do
    login_as(proxy)
    visit root_path
    click_link "add-content"
    classify_what_you_are_uploading 'Article'

    within '#new_article' do
      select user.name, :from => 'article_owner'
      fill_in "Title", with: "My article"
      fill_in "External link", with: "http://www.youtube.com/watch?v=oHg5SJYRHA0"
      choose('Visible to the world.')
      check("I have read and accept the contributor license agreement")
      click_button("Create Article")
    end

    page.should have_content(user.name)
  end

  it 'auto-selects proxy as contributor when Myself is selected as owner' do
    login_as(proxy)
    visit root_path
    click_link "add-content"
    classify_what_you_are_uploading 'Article'

    within '#new_article' do
      select 'Myself', :from => 'article_owner'
      fill_in "Title", with: "My article"
      fill_in "External link", with: "http://www.youtube.com/watch?v=oHg5SJYRHA0"
      choose('Visible to the world.')
      check("I have read and accept the contributor license agreement")
      click_button("Create Article")
    end

    page.should have_content(proxy.name)
  end

end
