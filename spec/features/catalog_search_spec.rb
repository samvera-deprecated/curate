require 'spec_helper'

describe_options = {type: :feature}
if ENV['JS']
  describe_options[:js] = true
end

describe 'catalog search', describe_options do
  it 'renders search results for null search' do
    visit('/')
    within('.search-form') do
      click_button("Go")
    end

    page.should have_tag('h3', text: "Search Results")
    page.should have_tag(".search-constraints", with_text: "You searched for:")
  end
end