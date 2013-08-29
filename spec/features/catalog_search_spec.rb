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

describe "Search for a work" do
  before { GenericWork.delete_all }
  let!(:work) { FactoryGirl.create(:public_work, 
    title: "McSweeney's Schlitz wolf, gentrify skateboard occupy Godard Cosby " +
    "sweater Carles cornhole swag next level.")}
  it "should find results" do
    visit('/')
    within('.search-form') do
      fill_in "Search Curate", with: 'skateboard Cosby'
      click_button("Go")
    end

    expect(page).to have_selector("#document_#{work.noid}")
  end
end
