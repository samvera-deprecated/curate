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
  context "when logged in" do
    let(:user) { FactoryGirl.create(:user) }
    let(:image_title) { "Sample Image" }
    before do
      login_as(user)
    end
    it "should have 'Add to Collection' link for Images" do
      create_collection
      create_image
      noid = page.current_path.split("/").last

      visit('/')
      within('.search-form') do
        fill_in "Search Curate", with: image_title
        click_button("keyword-search-submit")
      end
      href_link = add_member_form_collections_path(collectible_id: "#{Sufia.config.id_namespace}:#{noid}")
      page.should have_link("Add to Collection", href: href_link)
    end
  end

  protected
  def create_collection
    visit('/')
    click_on('Add a Collection')
    within '#new_collection' do
      fill_in "collection_title", with: "Sample Collection"
      click_button("Create Collection")
    end
  end

  def create_image
    visit('/')
    click_link "add-content"
    classify_what_you_are_uploading 'Image'
    within '#new_image' do
      fill_in "Title", with: image_title
      fill_in "Creator", with: user.name
      fill_in "Date created", with: "2013-10-15"
      fill_in "Description", with: "Test description"
      select(Sufia.config.cc_licenses.keys.first.dup, from: I18n.translate('sufia.field_label.rights'))
      check("I have read and accept the contributor license agreement")
      click_button("Create Image")
    end
  end

end
