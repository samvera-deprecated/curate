require 'spec_helper'

describe 'user profile workflow', FeatureSupport.options do

  describe 'editing your profile' do
    let(:password) { FactoryGirl.attributes_for(:user).fetch(:password) }
    let(:account) { FactoryGirl.create(:account) }
    let(:user) { account.user }

    it 'successfully updates your attributes' do
      login_as(user)

      visit edit_user_registration_path

      new_name = 'Frodo Baggins'
      new_pref = 'pref@example.com'
      new_alt = 'alt@example.com'
      new_title = 'student'
      new_phone = '12345'
      new_alt_phone = '67890'
      new_webpage = 'www.example.com'
      new_blog = 'blog.example.com'

      within('form.edit_user') do
        fill_in("user[current_password]", with: password)
        fill_in("user[name]", with: new_name)
        fill_in("user[email]", with: new_pref)
        fill_in("user[alternate_email]", with: new_alt)
        fill_in("user[title]", with: new_title)
        fill_in("user[campus_phone_number]", with: new_phone)
        fill_in("user[alternate_phone_number]", with: new_alt_phone)
        fill_in("user[personal_webpage]", with: new_webpage)
        fill_in("user[blog]", with: new_blog)
        click_button("Update")
      end

      msg = 'Your account has been updated successfully'
      expect(page).to have_content msg

      # Reload models
      user.reload
      user.person.reload

      # Verify that everything got updated
      user.name.should == new_name
      user.email.should == new_pref
      user.alternate_email.should == new_alt
      user.title.should == new_title
      user.campus_phone_number.should == new_phone
      user.alternate_phone_number.should == new_alt_phone
      user.personal_webpage.should == new_webpage
      user.blog.should == new_blog
    end
  end

  describe 'A new user who has not updated their profile yet' do
    let(:email) { 'hello@world.com' }
    let(:password) { 'my$3cur3p@$$word' }

    it 'can see the logout link' do
      logout
      visit new_user_registration_path
      sign_up_new_user(email, password)

      agree_to_tos
      assert_user_has_not_updated_their_profile_yet(email)

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

  describe 'when typing an invalid password' do
    let(:email) { 'badpasswordtest@gmail.com' }
    #this password is too short
    let(:password) { 'bad' }
    it do
      bad_login_for(email, password)
    end
  end

  def bad_login_for(email, password)
    logout
    visit('/')

    click_link("Log In")
    click_link("Sign up")
    sign_up_new_user(email, password)
    #Before HYDRASIR-381, the user would still get logged in (partially) when signing up with a bad password.
    page.assert_no_selector(".alert", "Welcome! You have signed up successfully.")
  end

  def first_time_login_for(email, password)
    logout
    visit('/')

    click_link("Log In")
    within("form.new_user") do
      fill_in("user[email]", with: email)
      fill_in("user[password]", with: password)
      click_button("Log in")
    end

    page.assert_selector(".alert", "Invalid email or password", count: 1)

    click_link("Sign up")
    sign_up_new_user(email, password)
    agree_to_tos

    within('form.edit_user') do
      fill_in("user[email]", with: new_email)
      fill_in("user[current_password]", with: password)
      click_button("Update Account")
    end
    click_link("add-content")

    assert_on_page_allowing_upload!
  end

  def second_time_login_for(email, password)
    logout
    visit('/')
    click_link("Log In")
    within("form.new_user") do
      fill_in("user[email]", with: email)
      fill_in("user[password]", with: password)
      click_button("Log in")
    end
    click_link("add-content")
    assert_on_page_allowing_upload!
  end

  def assert_on_page_allowing_upload!
    page.assert_selector("h2", text: "What are you uploading?", count: 1)
  end

  def assert_logout_link_is_visible
    # Because the link is hidden in a drop-down
    page.assert_selector("#site-actions .log-out", text: "Log Out", count: 1, visible: false)
  end

  def assert_user_has_not_updated_their_profile_yet(user_email)
    user = User.find_by_email(email)
    expect(user.user_does_not_require_profile_update?).to eq false
  end

  def sign_up_new_user(email, password)
    within("form.new_user") do
      fill_in("user[email]", with: email)
      fill_in("user[password]", with: password)
      fill_in("user[password_confirmation]", with: password)
      click_button("Sign up")
    end
  end

  def agree_to_tos
    within('form#terms_of_service') do
      click_button("I Agree")
    end
  end
end
