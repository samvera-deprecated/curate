require 'spec_helper'

describe 'manager profile workflow', FeatureSupport.options do

  describe 'editing other user\'s profile as a manager' do
    let(:manager_email) { 'manager@example.com' }
    let(:manager_account) { FactoryGirl.create(:account, email: manager_email) }
    let(:manager_user) { manager_account.user }
    let(:account) { FactoryGirl.create(:account) }
    let(:user) { account.user }

    it 'successfully updates other user\'s attributes' do
      login_as(manager_user)

      visit edit_user_path(user.id)

      new_name = 'Frodo Baggins'
      new_pref = 'pref@example.com'
      new_alt = 'alt@example.com'
      new_title = 'student'
      new_phone = '12345'
      new_alt_phone = '67890'
      new_webpage = 'www.example.com'
      new_blog = 'blog.example.com'

      within('form.edit_user') do
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
end
