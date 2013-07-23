require 'spec_helper_features'

describe_options = {type: :feature}
if ENV['JS']
  describe_options[:js] = true
end

describe 'user profile workflow', describe_options do

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

    within("form.new_user") do
      fill_in("user[email]", with: email)
      fill_in("user[password]", with: password)
      fill_in("user[password_confirmation]", with: password)
      click_button("Sign up")
    end
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
    assert_on_page_allowing_upload!
  end

  def assert_on_page_allowing_upload!
    page.assert_selector("h2", text: "What are you uploading?", count: 1)
  end
end
