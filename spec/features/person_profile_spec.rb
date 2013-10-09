require 'spec_helper'

describe 'Profile for a Person: ' do

  context 'logged in user' do
    let(:password) { FactoryGirl.attributes_for(:user).fetch(:password) }
    let(:account) { FactoryGirl.create(:account, display_name: 'Iron Man') }
    let(:user) { account.user }
    let(:person) { account.person }
    before { login_as(user) }

    # TODO: confirm the intent of this test
    it 'will see a link to their profile in the nav' do
      visit catalog_index_path
      page.should have_link("My Account", href: person_path(account.person))
    end

    it 'should see their name in the edit view' do
      visit catalog_index_path
      click_link 'My Account'
      click_link 'Update Personal Information'
      expect(page).to have_field('Name', with: 'Iron Man')
    end

    it 'should update their name and see the updated value' do
      visit catalog_index_path
      click_link 'My Account'
      click_link 'Update Personal Information'
      within('form.edit_user') do
        fill_in("user[name]", with: 'Spider Man')
        fill_in("user[current_password]", with: password)
        click_button "Update My Account"
      end

      visit catalog_index_path
      click_link 'My Account'
      page.should have_content('Spider Man')
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
