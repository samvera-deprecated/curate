require 'spec_helper'

describe 'Adding a section to a Profile: ' do

  context 'logged in user' do
    let(:account) { FactoryGirl.create(:account, name: 'Bilbo Baggins') }
    let(:user) { account.user }
    before { login_as(user) }

    it 'adds a section to their profile' do
      visit person_path(user.person)
      click_on 'Add a Section to my Profile'
      within('#new_profile_section') do
        fill_in('profile_section_title', with: 'New Collection on Bilbo')
        click_on 'Create Profile section'
      end
      page.should have_content('New Collection on Bilbo')
    end
  end

end
