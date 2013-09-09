require 'spec_helper'

describe 'Profile for a Person: ' do

  context 'logged in user' do
    let(:user) { FactoryGirl.create(:user) }
    before { login_as(user) }

    it 'will see a link to their profile in the nav' do
      visit dashboard_index_path
      page.should have_link("Profile", href: collection_path(user.person.profile))
    end
  end

end
