require 'spec_helper'

describe 'Profile for a Person: ' do

  context 'logged in user' do
    let(:account) { FactoryGirl.create(:account) }
    let(:user) { account.user }
    let(:person) { account.person }
    before { login_as(user) }

    it 'will see a link to their profile in the nav' do
      visit catalog_index_path
      page.should have_link("Profile", href: person_path(account.person))
    end
  end

end
