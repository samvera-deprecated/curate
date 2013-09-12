require 'spec_helper'

describe_options = {type: :feature}
if ENV['JS']
  describe_options[:js] = true
end

describe 'user profile workflow', describe_options do

  describe 'editing your profile', with_callbacks: true do
    let(:user) { FactoryGirl.create(:user) }

    it 'successfully updates your attributes' do
      login_as(user)
      visit edit_user_registration_path

      # Establish the starting state
      user.name.should == user.email
      user.preferred_email.should == nil
      user.alternate_email.should == user.email
      user.date_of_birth.should == nil
      user.gender.should == nil
      user.title.should == nil
      user.campus_phone_number.should == nil
      user.alternate_phone_number.should == nil
      user.personal_webpage.should == nil
      user.blog.should == nil

      new_name = 'Frodo Baggins'
      new_pref = 'pref@example.com'
      new_alt = 'alt@example.com'
      new_dob = '1/2/1980'
      new_gender = 'female'
      new_title = 'student'
      new_phone = '12345'
      new_alt_phone = '67890'
      new_webpage = 'www.example.com'
      new_blog = 'blog.example.com'

      within('form.edit_user') do
        fill_in("user[current_password]", with: user.password)

        fill_in("user[name]", with: new_name)
        fill_in("user[preferred_email]", with: new_pref)
        fill_in("user[alternate_email]", with: new_alt)
        fill_in("user[date_of_birth]", with: new_dob)
        fill_in("user[gender]", with: new_gender)
        fill_in("user[title]", with: new_title)
        fill_in("user[campus_phone_number]", with: new_phone)
        fill_in("user[alternate_phone_number]", with: new_alt_phone)
        fill_in("user[personal_webpage]", with: new_webpage)
        fill_in("user[blog]", with: new_blog)

        click_button("Update")
      end

      msg = 'You updated your account successfully'
      expect(page).to have_content msg

      # Reload models
      user.reload

      user.person.reload

      # Verify that everything got updated
      user.name.should == new_name
      user.preferred_email.should == new_pref
      user.alternate_email.should == new_alt
      user.date_of_birth.should == new_dob
      user.gender.should == new_gender
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
