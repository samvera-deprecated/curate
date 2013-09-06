require 'spec_helper'

describe 'Editing existing works' do
  let(:user) { FactoryGirl.create(:user) }
  let(:work) { FactoryGirl.create(:generic_work, user: user, title:"My Fabulous Work") }
  let(:dataset1) { FactoryGirl.create(:dataset, user: user, title:"Records from that Kiki") }
  let(:dataset2) { FactoryGirl.create(:dataset, user: user, title:"Records from that other Kiki") }

  before do
    work.related_works = [dataset1, dataset2]
    work.save
  end

  it "should allow you to associate them with each other" do
    login_as(user)
    visit curation_concern_generic_work_path(work)
    within ('table.related_works') do
      expect(page).to have_link(dataset1.title, href: polymorphic_path([:curation_concern, dataset1]))
      expect(page).to have_link(dataset2.title, href: polymorphic_path([:curation_concern, dataset2]))
    end
    unselect(dataset1.title, :from => 'generic_work_related_work_ids')
    select(dataset2.title, :from => 'generic_work_related_work_ids')
    click_button 'Update Related Works'
    within ('table.related_works') do
      expect(page).not_to have_content(dataset1.title)
      expect(page).to have_link(dataset2.title, href: polymorphic_path([:curation_concern, dataset2]))
    end
    click_link(dataset2.title)
    within ('table.referenced_by_works') do
      expect(page).to have_link(work.title, href: curation_concern_generic_work_path(work))
    end
  end
end
