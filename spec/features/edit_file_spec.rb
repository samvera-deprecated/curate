require "spec_helper"

describe "Editing an attached file" do
  let(:user) { FactoryGirl.create(:user) }
  let(:work) { FactoryGirl.create(:generic_work_with_files, file_count: 1, user: user) }

  it 'should allow me to edit the file' do
    login_as(user)
    visit curation_concern_generic_work_path(work)
    within '.generic_file.attributes' do
      click_link 'Edit'
    end
    fill_in "Title", with: 'Test title'
    click_button "Update Attached File"

    expect(page).to have_selector('table.attributes tbody tr:first td', text: 'Test title')
    click_link "Edit this File"

    find_field('Title').value.should eq 'Test title'
  end
end
