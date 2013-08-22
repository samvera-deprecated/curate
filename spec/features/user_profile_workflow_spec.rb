require 'spec_helper'

describe_options = {type: :feature}
if ENV['JS']
  describe_options[:js] = true
end

describe 'user profile workflow', describe_options do

  describe 'A new user who has not updated their profile yet' do
    let(:email) { 'hello@world.com' }
    let(:password) { 'my$3cur3p@$$word' }

    it 'can see the logout link' do
      logout
      visit new_user_registration_path
      sign_up_new_user(email, password)

      assert_user_has_not_updated_their_profile_yet(email)
      assert_logout_link_is_visible

      visit dashboard_index_path
      assert_logout_link_is_visible
    end
  end

  describe 'when I have not yet logged into Curate' do
    let(:email) { 'hello@world.com' }
    let(:new_email) { "awesome-#{email}" }
    let(:password) { 'my$3cur3p@$$word' }
    it do
      first_time_login_for(email, password)
      second_time_login_for(new_email, password)
    end
  end

  def first_time_login_for(email, password)
    logout
    visit('/')
    click_link('Get Started')

    within("form.new_user") do
      fill_in("user[email]", with: email)
      fill_in("user[password]", with: password)
      click_button("Sign in")
    end

    page.assert_selector(".alert", "Invalid email or password", count: 1)

    click_link("Sign up")
    sign_up_new_user(email, password)

    within('form#terms_of_service') do
      click_button("I Agree")
    end
    within('form.edit_user') do
      fill_in("user[email]", with: new_email)
      fill_in("user[current_password]", with: password)
      click_button("Update")
    end
    click_link("Get Started")
    assert_on_page_allowing_upload!
  end

  def second_time_login_for(email, password)
    logout
    visit('/')
    click_link('Get Started')
    within("form.new_user") do
      fill_in("user[email]", with: email)
      fill_in("user[password]", with: password)
      click_button("Sign in")
    end
    click_link("Submit a work")
    assert_on_page_allowing_upload!
  end

  def assert_on_page_allowing_upload!
    page.assert_selector("h2", text: "What are you uploading?", count: 1)
  end

  def assert_logout_link_is_visible
    page.should have_link("Log Out", href: destroy_user_session_path)
  end

  def assert_user_has_not_updated_their_profile_yet(user_email)
    user = User.find_by_email(email)
    assert !user.user_does_not_require_profile_update
  end

  def sign_up_new_user(email, password)
    within("form.new_user") do
      fill_in("user[email]", with: email)
      fill_in("user[password]", with: password)
      fill_in("user[password_confirmation]", with: password)
      click_button("Sign up")
    end
  end
end
