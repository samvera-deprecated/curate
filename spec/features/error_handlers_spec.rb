require 'spec_helper'

require 'casclient'
require 'casclient/frameworks/rails/filter'

describe_options = {type: :feature}
if ENV['JAVASCRIPT']
  describe_options[:js] = true
end

describe 'error behavior', describe_options do
  it 'handles missing route with 404' do
    visit('/apollo')
    expect(page).to have_content('The page you are looking for may have been removed, had its name changed, or is temporarily unavailable.')
    expect(page).to have_content("Not Found")
  end
  it 'handles non-existent noid for common objects with 404' do
    visit('/show/invalid_noid')
    expect(page).to have_content('The page you are looking for may have been removed, had its name changed, or is temporarily unavailable.')
    expect(page).to have_content("Not Found")
  end

  it 'handles unauthorized pages'do
    user = FactoryGirl.create(:user)
    curation_concern = FactoryGirl.create_curation_concern(:senior_thesis, user, visibility: 'psu')

    visit("/concern/senior_theses/#{curation_concern.to_param}")
    expect(page).to have_content("Unauthorized")
    expect(page).to have_content("You are not authorized to access the page.")
  end
end