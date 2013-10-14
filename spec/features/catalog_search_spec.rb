require 'spec_helper'

describe_options = {type: :feature}
if ENV['JS']
  describe_options[:js] = true
end

describe 'catalog search', describe_options do
  before do
    Rails.configuration.consider_all_requests_local = true
  end
  after do
    Rails.configuration.consider_all_requests_local = false unless ENV['LOCAL']
  end
  it 'renders search results for null search' do
    visit('/')
    within('.search-form') do
      fill_in "Search Curate", with: 'some work'
      click_button("keyword-search-submit")
    end

    page.should have_tag(".search-constraints", with_text: "Limited to:")
    page.should have_tag('ul#documents')
  end
end

describe "Search for a work" do
  context "when not logged in" do
    before { GenericWork.delete_all }
    let!(:public_work) { FactoryGirl.create(:public_generic_work,
      title: "McSweeney's Schlitz wolf, gentrify skateboard occupy Godard Cosby " +
      "sweater Carles cornhole swag next level.")}
    let!(:private_work) { FactoryGirl.create(:private_generic_work,
      title: "McSweeney's Schlitz wolf, gentrify skateboard occupy Godard Cosby " +
      "sweater Carles cornhole swag next level.")}
    it "should find results" do
      visit('/')
      within('.search-form') do
        fill_in "Search Curate", with: 'skateboard Cosby'
        click_button("keyword-search-submit")
      end

      expect(page).to have_selector("#document_#{public_work.noid}")
      expect(page).to_not have_selector("#document_#{private_work.noid}")
    end
  end
end
