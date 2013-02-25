require 'spec_helper'

require 'casclient'
require 'casclient/frameworks/rails/filter'

describe 'welcome page authentication', type: :feature do
  before(:each) do
    Warden.test_mode!
  end
  after(:each) do
    Warden.test_reset!
  end
  let(:user) { FactoryGirl.create(:user, agreed_to_terms_of_service: agreed_to_terms_of_service) }

  describe 'with user who has already agreed to the terms of service' do
    let(:agreed_to_terms_of_service) { true }
    it "displays the start uploading" do
      login_as(user, scope: :user, run_callbacks: false)
      visit '/'
      click_link "Get Started"
      page.should have_content("What are you uploading?")
    end
  end
  describe 'with user who has _not_ agreed to the terms of service' do
    let(:agreed_to_terms_of_service) { false }
    it "displays the terms of service page after authentication" do
      login_as(user, scope: :user, run_callbacks: false)
      visit '/'
      click_link "Get Started"
      page.should_not have_content("What are you uploading?")
      within('#terms_of_service') do
        click_on("I Agree")
      end
      page.should have_content("What are you uploading?")
    end
  end
end