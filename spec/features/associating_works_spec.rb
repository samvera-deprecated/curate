require 'spec_helper'

describe_options = {type: :feature}
if ENV['JS']
  describe_options[:js] = true
end

describe 'Editing existing works', describe_options do
  let(:user) { FactoryGirl.create(:user) }
  let(:work) { FactoryGirl.create(:generic_work, user: user, title:"My Fabulous Work") }
  let(:dataset1) { FactoryGirl.create(:dataset, user: user, title:"Records from that Kiki") }
  let(:dataset2) { FactoryGirl.create(:dataset, user: user, title:"Records from that other Kiki") }

  it "should allow you to associate them with each other" do
    login_as(user)
    visit curation_concern_generic_work_path(work)
    if with_javascript?
      #
      # Associating Works Using Autocomplete
      #
      [DashboardController, CurationConcern::GenericWorksController, CurationConcern::DatasetsController].each do |ctlr|
        ctlr.any_instance.stub(:authenticate_user!).and_return(user)
        ctlr.any_instance.stub(:current_user).and_return(user)
      end
      puts [work.pid, dataset1.pid, dataset2.pid].join(", ") # For some reason, this line ensures that the datasets show up when the dashboard queries solr
      # ADDING [js]
      within (".token-input-list-facebook") do
        page.should_not have_field(".token-input-token-facebook")
      end
      fill_in 'token-input-generic_work_related_work_tokens', :with => "Records"
      page.find(".token-input-dropdown-facebook li", text: dataset1.title).click
      fill_in 'token-input-generic_work_related_work_tokens', :with => "Records"
      page.find(".token-input-dropdown-facebook li", text: dataset2.title).click
      click_button 'Update Related Works'
      within (".token-input-list-facebook") do
        page.should have_selector(".token-input-token-facebook", text:dataset1.title)
        page.should have_selector(".token-input-token-facebook", text:dataset2.title)
      end
      # REMOVING [js]
      within (".token-input-list-facebook") do
        # select dataset1 token
        page.find(".token-input-token-facebook", text: dataset1.title).click
        # click the 'delete' trigger on the selected token
        page.find(".token-input-selected-token-facebook .token-input-delete-token-facebook").click
      end
      click_button 'Update Related Works'
      within (".token-input-list-facebook") do
        page.should_not have_selector(".token-input-token-facebook", text:dataset1.title)
        page.should have_selector(".token-input-token-facebook", text:dataset2.title)
      end
    else
      #
      # Associating Works without Javascript
      #
      # ADDING [plain]
      page.should have_field("generic_work_related_work_tokens", with: "")
      fill_in 'generic_work_related_work_tokens', :with => [dataset1.pid, dataset2.pid].join(", ")
      click_button 'Update Related Works'
      find_field('generic_work_related_work_tokens').value.split(', ').should include(dataset1.pid, dataset2.pid)
      # REMOVING [plain]
      fill_in 'generic_work_related_work_tokens', :with => dataset2.pid
      click_button 'Update Related Works'
      page.should have_field("generic_work_related_work_tokens", with: dataset2.pid)
    end
    visit curation_concern_dataset_path(dataset2)
    within ('table.referenced-by-works') do
      expect(page).to have_link(work.title, href: curation_concern_generic_work_path(work))
    end
  end
end
