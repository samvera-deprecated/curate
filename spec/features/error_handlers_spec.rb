require 'spec_helper'

describe_options = {type: :feature}
if ENV['JS']
  describe_options[:js] = true
end

describe 'error behavior', describe_options do
  before(:each) do
    @initial_consider_all_requests_local = Rails.configuration.consider_all_requests_local
    Rails.configuration.consider_all_requests_local = false
  end
  after(:each) do
    Rails.configuration.consider_all_requests_local = @initial_consider_all_requests_local
  end

  it 'handles non-existent noid for common objects with 404' do
    visit('/show/invalid_noid')
    expect(page).to have_content('The page you are looking for may have been removed, had its name changed, or is temporarily unavailable.')
    expect(page).to have_content("Not Found")
  end

  let(:curation_concern_type) { :generic_work }
  let(:user) { FactoryGirl.create(:user) }
  let(:curation_concern) { FactoryGirl.create(:private_generic_work) }
  it 'handles unauthorized pages'do
    login_as user
    visit edit_curation_concern_generic_work_path(curation_concern)
    expect(page).to have_content("Unauthorized")
    expect(page).to have_content("You are not authorized to access the page.")
  end
end
