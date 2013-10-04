require 'spec_helper'

describe 'Profile for a Person: ' do

  context 'logged in user' do
    let(:account) { FactoryGirl.create(:account) }
    let(:user) { account.user }
    let(:person) { account.person }
    before { login_as(user) }

    # TODO: confirm the intent of this test
    it 'will see a link to their profile in the nav' do
      visit catalog_index_path
      page.should have_link("My Account", href: person_path(account.person))
    end
  end

  context "searching" do
    before do
      FactoryGirl.create(:account, name: 'Marguerite Scypion' )
    end
    it 'is displayed in the results' do
      visit catalog_index_path
      fill_in 'Search Curate', with: 'Marguerite'
      click_button 'Go'
      within('#documents') do
        expect(page).to have_link('Marguerite Scypion') #title
      end
    end
  end

end
