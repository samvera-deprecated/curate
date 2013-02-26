require 'spec_helper'

require 'casclient'
require 'casclient/frameworks/rails/filter'

describe 'end to end behavior', type: :feature do
  before(:each) do
    Warden.test_mode!
    @old_resque_inline_value = Resque.inline
    Resque.inline = true
  end
  after(:each) do
    Warden.test_reset!
    Resque.inline = @old_resque_inline_value
  end
  let(:user) { FactoryGirl.create(:user, agreed_to_terms_of_service: agreed_to_terms_of_service) }
  let(:prefix) { Time.now.strftime("%Y-%m-%d-%H-%M-%S-%L") }
  let(:initial_title) { "#{prefix} Something Special" }
  let(:initial_file_path) { __FILE__ }
  let(:updated_title) { "#{prefix} Another Not Quite" }
  let(:updated_file_path) { Rails.root.join('app/controllers/application_controller.rb').to_s }

  describe 'with user who has already agreed to the terms of service' do
    let(:agreed_to_terms_of_service) { true }
    it "displays the start uploading" do
      login_as(user, scope: :user, run_callbacks: false)
      visit '/'
      click_link "Get Started"
      page.should have_content("What are you uploading?")
    end
  end
  describe 'with a user who has not agreed to terms of service' do
    let(:agreed_to_terms_of_service) { false }
    it "displays the terms of service page after authentication" do
      login_as(user, scope: :user, run_callbacks: false)

      get_started
      agree_to_terms_of_service
      classify_what_you_are_uploading
      describe_your_thesis
      view_your_new_thesis
      edit_your_thesis
      view_your_updated_thesis
      view_your_dashboard
    end
    protected
    def get_started
      visit '/'
      click_link "Get Started"
    end

    def agree_to_terms_of_service
      within('#terms_of_service') do
        click_on("I Agree")
      end
    end

    def classify_what_you_are_uploading
      page.should have_content("What are you uploading?")
      within('#new_classify') do
        select('Senior Thesis', from: 'classify_curation_concern')
        click_on("Continue")
      end
    end
    def describe_your_thesis
      page.should have_content('Describe Your Thesis')
      within('#new_senior_thesis') do
        fill_in("Title", with: initial_title)
        attach_file("Upload your thesis", initial_file_path)
        check("Accept contributor agreement")
        click_on("Create Senior thesis")
      end
    end

    def view_your_new_thesis
      page.should have_content("Thesis Details")
      within(".senior_thesis.attributes") do
        page.should have_content("Title")
        page.should have_content(initial_title)
      end
      within(".generic_file.attributes") do
        page.should have_content(File.basename(initial_file_path))
        page.should have_content("Mime type: text/plain")
      end
    end

    def edit_your_thesis
      click_on("Edit Senior Thesis")
      within('.edit_senior_thesis') do
        fill_in("Title", with: updated_title)
        page.should have_content("Current thesis file:")
        page.should have_content(File.basename(initial_file_path))
        attach_file("Upload a new copy of your thesis", updated_file_path)
        click_on("Update Senior thesis")
      end
    end
    def view_your_updated_thesis
      page.should have_content("Thesis Details")
      within(".senior_thesis.attributes") do
        page.should have_content("Title")
        page.should have_content(updated_title)
      end
      page.should have_content("File Details")
      page.should have_content(File.basename(updated_file_path))
      click_on("Back to Dashboard")
    end

    def view_your_dashboard
      search_term = "\"#{updated_title}\""
      within(".form-search") do
        fill_in("q", with: search_term)
        click_on("Go")
      end
      page.should have_content(updated_title)
      within('.alert.alert-info') do
        page.should have_content("You searched for: #{search_term}")
      end

      within('#facets') do
        # I call CSS/Dom shenannigans; I can't access 'Creator' link
        # directly and instead must find by CSS selector, validate it
        creator_facet = find('a.accordion-toggle')
        creator_facet.text.should == 'Creator'
        creator_facet.click
        click_on(user.username)
      end
      within('.alert.alert-info') do
        page.should have_content("You searched for: #{search_term}")
      end
      within('.alert.alert-warning') do
        page.should have_content(user.username)
      end
    end
  end
end
