require 'spec_helper'

describe 'Editing existing works' do
  let(:user) { FactoryGirl.create(:user) }
  let(:work) { FactoryGirl.create(:generic_work, user: user, title:"My Fabulous Work") }
  let(:dataset1) { FactoryGirl.create(:dataset, user: user, title:"Records from that Kiki") }
  let(:dataset2) { FactoryGirl.create(:dataset, user: user, title:"Records from that other Kiki") }

  it "should allow you to associate them with each other" do
    login_as(user)
    visit curation_concern_generic_work_path(work)
    #within ('table.related_works') do
    #  expect(page).to have_link(dataset1.title, href: polymorphic_path([:curation_concern, dataset1]))
    #  expect(page).to have_link(dataset2.title, href: polymorphic_path([:curation_concern, dataset2]))
    #end
    page.should have_field("generic_work_related_work_tokens", with: "")
    fill_in 'generic_work_related_work_tokens', :with => [dataset1.pid, dataset2.pid].join(", ")
    click_button 'Update Related Works'
    page.should have_field("generic_work_related_work_tokens", with: [dataset1.pid, dataset2.pid].join(", "))
    fill_in 'generic_work_related_work_tokens', :with => dataset2.pid
    click_button 'Update Related Works'
    page.should have_field("generic_work_related_work_tokens", with: dataset2.pid)
    #within ('table.related_works') do
    #  expect(page).not_to have_content(dataset1.title)
    #  expect(page).to have_link(dataset2.title, href: polymorphic_path([:curation_concern, dataset2]))
    #end
    #click_link(dataset2.title)
    visit curation_concern_generic_work_path(dataset2)
    within ('table.referenced_by_works') do
      expect(page).to have_link(work.title, href: curation_concern_generic_work_path(work))
    end
  end
end
