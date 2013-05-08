require 'spec_helper'

require 'casclient'
require 'casclient/frameworks/rails/filter'

describe_options = {type: :feature}
if ENV['JS']
  describe_options[:js] = true
end

describe 'end to end behavior', describe_options do
  def with_javascript?
    @example.metadata[:js] || @example.metadata[:javascript]
  end

  before(:each) do
    Warden.test_mode!
    @old_resque_inline_value = Resque.inline
    Resque.inline = true
  end
  after(:each) do
    Warden.test_reset!
    Resque.inline = @old_resque_inline_value
  end
  let(:sign_in_count) { 0 }
  let(:user) {
    FactoryGirl.create(
      :user,
      agreed_to_terms_of_service: agreed_to_terms_of_service,
      sign_in_count: sign_in_count
    )
  }
  let(:another_user) {
    FactoryGirl.create(
      :user,
      agreed_to_terms_of_service: true,
      sign_in_count: sign_in_count
    )
  }
  let(:prefix) { Time.now.strftime("%Y-%m-%d-%H-%M-%S-%L") }
  let(:initial_title) { "#{prefix} Something Special" }
  let(:initial_file_path) { __FILE__ }
  let(:updated_title) { "#{prefix} Another Not Quite" }
  let(:updated_file_path) { Rails.root.join('app/controllers/application_controller.rb').to_s }

  def follow_created_curation_concern_link!
    find('.created_curation_concern').click
  end

  describe 'user profile' do
    let(:agreed_to_terms_of_service) { true }
    let(:sign_in_count) { 2 }
    let(:expected_email) { 'hello@world.com' }
    it 'allows me to edit my email' do
      expect(user.email).to be_empty
      login_as(user)
      visit('/dashboard')
      within('.page-actions') do
        click_link('Profile')
      end
      within('form.edit_user') do
        fill_in('Alternate email', with: expected_email)
        click_button('Update')
      end
      page.should have_content('You updated your account successfully.')
      within('.page-actions') do
        click_link('Profile')
      end
      within('form.edit_user') do
        expect(find('#user_email').value).to eq(expected_email)
      end
    end
  end

  describe 'terms of service' do
    let(:agreed_to_terms_of_service) { false }
    it "only requires me to agree once" do
      login_as(user)
      visit('/')
      click_link('Get Started')
      agree_to_terms_of_service
      logout(:user)

      visit('/')

      login_as(user)
      click_link('Get Started')
      page.assert_selector('#terms_of_service', count: 0)
    end
  end

  describe 'with user who has already agreed to the terms of service' do
    let(:agreed_to_terms_of_service) { true }

    describe 'having not signed in before' do
      let(:sign_in_count) { 0 }
      it "displays the start uploading" do
        login_as(user)
        visit '/'
        click_link "Get Started"
        page.should have_content("What are you uploading?")
      end
    end

    describe 'having signed in before' do
      let(:sign_in_count) { 2 }
      it "allows me to directly create a senior thesis" do
        login_as(user)
        visit('/concern/senior_theses/new')
        page.assert_selector('.main-header h2', "Describe Your Senior Thesis")
      end

      it 'remembers senior thesis inputs when data was invalid' do
        login_as(user)
        visit('/concern/senior_theses/new')
        create_senior_thesis(
          'Visibility' => 'visibility_restricted',
          'I Agree' => true,
          'Title' => ''
        )
        page.assert_selector('.main-header h2', "Describe Your Senior Thesis")
        expect(page).to have_checked_field('visibility_restricted')
        expect(page).to_not have_checked_field('visibility_open')
      end

      it "a public item with future embargo is not visible today but is in the future" do
        embargo_release_date = 2.days.from_now
        # Because the JS will transform an unexpected input entry to the real
        # today (browser's date), and I want timecop to help
        embargo_release_date_formatted = embargo_release_date.strftime("%Y-%m-%d")
        login_as(user)
        visit('/concern/senior_theses/new')
        create_senior_thesis(
          'Embargo Release Date' => embargo_release_date_formatted,
          'Visibility' => 'visibility_open',
          'Contributors' => ['Dante'],
          'I Agree' => true
        )

        follow_created_curation_concern_link!

        page.assert_selector(
          ".embargo_release_date.attribute",
          text: embargo_release_date_formatted
        )
        page.assert_selector(
          ".permission.attribute",
          text: "Open Access"
        )
        noid = page.current_path.split("/").last
        logout(:user)
        visit("/show/#{noid}")

        page.assert_selector('.contributor.attribute', text: 'Dante', count: 0)
        page.assert_selector('h1', text: "Object Not Available")

        # Seconds are weeks
        begin
          Timecop.scale(60*60*24*7)
          sleep(1)
        ensure
          Timecop.scale(1)
        end
        visit("/show/#{noid}")
        expect(Time.now > embargo_release_date).to be_true

        # With the embargo release date passed an anonymous user should be able
        # to see it.
        page.assert_selector('h1', text: "Object Not Available", count: 0)
      end
    end
  end

  describe 'help request' do
    let(:agreed_to_terms_of_service) { true }
    let(:sign_in_count) { 20 }

    it "with JS is available for users who are authenticated and agreed to ToS", js: true do
      login_as(user)
      visit('/')
      click_link("Get Started")
      click_link "Request Help"
      within("#new_help_request") do
        fill_in('How can we help you', with: "I'm trapped in a fortune cookie factory!")
        click_on("Let Us Know")
      end
      page.assert_selector('.notice', text: HelpRequestsController::SUCCESS_NOTICE)
    end

    it "without JS is available for users who are authenticated and agreed to ToS", js: false do
      login_as(user)
      visit('/')
      click_link("Get Started")
      click_link "Request Help"
      within("#new_help_request") do
        fill_in('How can we help you', with: "I'm trapped in a fortune cookie factory!")
        click_on("Let Us Know")
      end
      page.assert_selector('.notice', text: HelpRequestsController::SUCCESS_NOTICE)
    end

  end

  describe '+Add javascript behavior', js: true do
    let(:contributors) { ["D'artagnan", "Porthos", "Athos", 'Aramas'] }
    let(:agreed_to_terms_of_service) { true }
    let(:sign_in_count) { 2 }
    let(:title) {"Somebody Special's Senior Thesis" }
    it 'handles contributor', js: true do
      login_as(user)
      visit('/concern/senior_theses/new')
      create_senior_thesis(
        "Title" => title,
        "Upload Files" => initial_file_path,
        "Contributors" => contributors,
        "I Agree" => true
      )
      follow_created_curation_concern_link!
      page.should have_content(title)
      contributors.each do |contributor|
        page.assert_selector(
          '.senior_thesis.attributes .contributor.attribute',
          text: contributor
        )
      end
    end
  end

  describe 'with a user who has agreed to ToS' do
    let(:agreed_to_terms_of_service) { true }
    let(:sign_in_count) { 2 }
    let(:embargo_release_date) { 2.days.from_now }
    let(:embargo_release_date_formatted) { embargo_release_date.strftime("%Y-%m-%d") }

    # CAS does not yet fully log you out of the site, so I want to verify that
    # if I log out, I don't see it.
    it 'when they create an embargoed file then log out they should not see it' do
      login_as(user)
      visit('/concern/senior_theses/new')
      url = create_senior_thesis(
        "Title" => "A Title",
        "Upload Files" => __FILE__,
        "Contributors" => ['Washington, George'],
        "I Agree" => true,
        'Embargo Release Date' => embargo_release_date_formatted
      )
      logout(:user)
      follow_created_curation_concern_link!
      page.should have_content('Unauthorized')
    end
  end

  describe 'with a user who has not agreed to terms of service' do
    let(:agreed_to_terms_of_service) { false }
    let(:sign_in_count) { 2 }
    it "displays the terms of service page after authentication" do
      login_as(user)
      get_started
      agree_to_terms_of_service
      classify_what_you_are_uploading('Senior Thesis')
      create_senior_thesis('I Agree' => true, 'Visibility' => 'visibility_open')
      follow_created_curation_concern_link!
      path_to_view_thesis = view_your_new_thesis
      path_to_edit_thesis = edit_your_thesis
      view_your_updated_thesis
      view_your_dashboard

      logout(:user)
      login_as(another_user)
      other_persons_thesis_is_not_in_my_dashboard
      i_can_see_another_users_open_resource(path_to_view_thesis)
      i_cannot_edit_to_another_users_resource(path_to_edit_thesis)
    end
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

  def classify_what_you_are_uploading(concern)
    page.should have_content("What are you uploading?")
    find("a.btn.add_new_senior_thesis").click
  end

  def click_continue_for_pane(i)

  end

  def create_senior_thesis(options = {})
    options['Abstract'] ||= 'Lorem Ipsum'
    options['Title'] ||= initial_title
    options['Authors'] ||= ["Johnny Student"]
    options['Upload Files'] ||= initial_file_path
    options['Visibility'] ||= 'visibility_restricted'
    options["Button to click"] ||= "Create Senior thesis"
    options["Contributors"] ||= ["Dante"]
    options["Content License"] ||= Sufia::Engine.config.cc_licenses.keys.first

    page.should have_content('Describe Your Senior Thesis')
    # Without accepting agreement
    within('#new_senior_thesis') do

      # 0th Pane
      fill_in("Title", with: options['Title'])
      fill_in("Abstract", with: options['Abstract'])
      fill_out_form_multi_value_for('creator', with: options['Authors'])
      select(options['Content License'], from: 'Content License')
      if options['Assign DOI']
        check('senior_thesis_assign_doi')
      end
      click_continue_for_pane(0)

      # 1st Pane
      fill_out_form_multi_value_for('contributor', with: options['Contributors'])
      click_continue_for_pane(1)

      # 2nd Pane
      choose(options['Visibility'])
      if options['Embargo Release Date']
        fill_in("senior_thesis_embargo_release_date", with: options["Embargo Release Date"])
      end
      click_continue_for_pane(2)

      # 3rd Pane
      attach_file("Upload Files", options['Upload Files'])
      if options['I Agree']
        check("I have read and accept the contributor licence agreement")
      end
      click_on(options["Button to click"])
    end

    if !options["I Agree"]
      within('.alert.error') do
        page.should have_content('You must accept the contributor agreement')
      end
      page.should have_content("Describe Your Senior Thesis")
    end
  end

  def fill_out_form_multi_value_for(method_name, options={})
    field_name = "senior_thesis[#{method_name}][]"
    within(".senior_thesis_#{method_name}.multi_value") do
      elements = [options[:with]].flatten.compact
      if with_javascript?
        elements.each_with_index do |contributor, i|
          within('.input-append:last') do
            fill_in(field_name, with: contributor)
            click_on('Add')
          end
        end
      else
        fill_in(field_name, with: elements.first)
      end
    end
  end

  def add_a_related_file(options = {})
    options['Title'] ||= initial_title
    options['Upload a file'] ||= initial_file_path
    options['Visibility'] ||= 'visibility_restricted'
    within("form.new_generic_file") do
      fill_in("Title", with: options['Title'])
      attach_file("Upload a file", options['Upload a file'])
      choose(options['Visibility'])
      click_on("Attach to Senior Thesis")
    end
  end

  def view_your_new_thesis
    path_to_view_thesis  = page.current_path
    page.should have_content("Files")
    page.should have_content(initial_title)
    within(".generic_file.attributes") do
      page.should have_content(File.basename(initial_file_path))
    end

    return path_to_view_thesis
  end

  def edit_your_thesis
    click_on("Edit This Senior Thesis")
    edit_page_path = page.current_path
    within('.edit_senior_thesis') do
      fill_in("Title", with: updated_title)
      fill_in("Abstract", with: "Lorem Ipsum")
      click_on("Update Senior thesis")
    end
    return edit_page_path
  end
  def view_your_updated_thesis
    page.should have_content("Files")
    page.should have_content(updated_title)
    click_on("Back to Dashboard")
  end

  def view_your_dashboard
    search_term = "\"#{updated_title}\""

    within(".search-form") do
      fill_in("q", with: search_term)
      click_on("Go")
    end

    within('#documents') do
      page.should have_content(updated_title)
    end
    within('.alert.alert-info') do
      page.should have_content("You searched for: #{search_term}")
    end

    within('#facets') do
      # I call CSS/Dom shenannigans; I can't access 'Creator' link
      # directly and instead must find by CSS selector, validate it
      all('a.accordion-toggle').each do |elem|
        if elem.text == 'Type'
          elem.click
        end
      end
      click_on('Senior Thesis')
    end
    within('.alert.alert-info') do
      page.should have_content("You searched for: #{search_term}")
    end
    within('.alert.alert-warning') do
      page.should have_content('Senior Thesis')
    end
  end

  def other_persons_thesis_is_not_in_my_dashboard
    visit "/dashboard"
    search_term = "\"#{updated_title}\""
    within(".search-form") do
      fill_in("q", with: search_term)
      click_on("Go")
    end
    within('#documents') do
      page.should_not have_content(updated_title)
    end
  end

  def i_can_see_another_users_open_resource(path_to_other_persons_resource)
    visit path_to_other_persons_resource
    page.should have_content(updated_title)
  end

  def i_cannot_edit_to_another_users_resource(path_to_other_persons_resource)
    visit path_to_other_persons_resource
    page.should_not have_content("Please consider releasing your thesis as an Open Access work. ")
    page.should have_content("Unauthorized")
  end
end
