require 'spec_helper'

describe 'Uploading Generic File' do
  let(:user) { FactoryGirl.create(:user) }
  let(:another_user) { FactoryGirl.create(:user) }

  context "editing my own work" do
    let(:work) { FactoryGirl.create(:public_generic_work, user: user) }
    before do
      login_as user
      visit curation_concern_generic_work_path(work)
    end

    it 'there will be a cancle link on the edit page' do
      click_link "Edit This Generic Work"
      expect(page).to have_link('Cancel', curation_concern_generic_work_path(work))
    end
    it 'there will be a cancle link on the attach file page' do
      click_link "Attach a File"
      expect(page).to have_link('Cancel', curation_concern_generic_work_path(work))
    end

  end

  context 'a public work that contains a public file' do
    let(:public_work) { FactoryGirl.create(:public_generic_work, user: another_user) }
    before { upload_my_file(public_work, 'visibility_open') }

    context 'when the user views the public work' do
      before do
        login_as user
        visit curation_concern_generic_work_path(public_work)
      end

      it 'there will be a link to the file show page' do
        public_work.generic_files.count.should == 1
        file = public_work.generic_files.first
        expect(page).to have_link('image.png', curation_concern_generic_file_path(file))
      end

      it 'there should be a link pointing back to parent from generic_file show view' do
        visit curation_concern_generic_file_path(public_work.generic_files.first)
        expect(page).to have_link('Back to Generic Work')
      end
    end
  end

  context 'a public work that contains a private file' do
    let(:public_work) { FactoryGirl.create(:public_generic_work, user: another_user) }
    before { upload_my_file(public_work, 'visibility_restricted') }

    context 'when the user views the public work' do
      before do
        login_as user
        visit curation_concern_generic_work_path(public_work)
      end

      it 'the file name for the private file is not visible' do
        public_work.generic_files.count.should == 1
        file = public_work.generic_files.first
        expect(page).to have_link('File', curation_concern_generic_file_path(file))
        expect(page).to_not have_text('image.png')
      end
    end
  end

  context 'when a representative file is deleted' do
    let!(:public_work) { FactoryGirl.create(:public_generic_work, user: user) }
    let(:file1) {File.join(fixture_path, 'files/image.png')}
    let(:file2) {File.join(fixture_path, 'files/image_2.png')}

    before { upload_file(public_work, file1, 'visibility_restricted') }
    it 'should clear the representative attribute of the parent' do
      login_as user
      visit curation_concern_generic_work_path(public_work)
      expect(page).to have_link('image.png')
      expect(page).to_not have_link('image_2.png')
      public_work.reload.representative.should_not be_empty
      representative_image =  public_work.reload.representative

      upload_file(public_work, file2, 'visibility_restricted')

      visit curation_concern_generic_work_path(public_work)
      expect(page).to have_link('image.png')
      expect(page).to have_link('image_2.png')

      first('.generic_file.attributes').click_link('Delete')
      expect(page).to_not have_link('image.png')
      expect(page).to have_link('image_2.png')
      public_work.reload.representative.should_not == representative_image
    end
  end

  context 'Viewing generic work that has generic file with empty content' do
    let!(:generic_work) { FactoryGirl.create(:public_generic_work, user: user) }
    let(:user) { FactoryGirl.create(:user) }
    let(:visibility) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE }
    let(:file) { Rack::Test::UploadedFile.new(__FILE__, 'text/plain', false) }
    let(:generic_file_without_content) {
      FactoryGirl.create_generic_file(generic_work, user) {|g|
        g.visibility = visibility
      }
    }
    let(:generic_file_with_content) {
      FactoryGirl.create_generic_file(generic_work, user,file)
    }
    it 'the file name for the empty file File upload error and show alert message' do
      generic_file_without_content
      login_as user
      visit curation_concern_generic_work_path(generic_work)
      generic_work.generic_files.count.should == 1
      
      expect(page).to have_link('Resolve', edit_curation_concern_generic_file_path(file))
      expect(page).to have_link('File Upload Error', curation_concern_generic_file_path(file))
      expect(page).to have_selector('div', text: 'It looks like there is a problem with one of these files.')
    end

    it 'should not show alert when there is content' do
      generic_file_with_content
      login_as user
      visit curation_concern_generic_work_path(generic_work)
      generic_work.generic_files.count.should == 1
      expect(page).to have_link('File', curation_concern_generic_file_path(file))
      expect(page).to have_text('generic_file_spec.rb')
      expect(page).to_not have_selector('.alert', text: 'It looks like there is a problem with one of these files.')
    end
  end

  context 'editing generic work that has generic file with empty content' do
    let!(:generic_work) { FactoryGirl.create(:public_generic_work, user: user) }
    let(:user) { FactoryGirl.create(:user) }
    let(:file) { Rack::Test::UploadedFile.new(__FILE__, 'text/plain', false) }
    let(:generic_file_without_content) {
      FactoryGirl.create_generic_file(generic_work, user)
    }
    let(:generic_file_with_content) {
      FactoryGirl.create_generic_file(generic_work, user,file)
    }
    it 'Generic work should alert about files being empty' do
      generic_file_without_content
      login_as user
      visit edit_curation_concern_generic_work_path(generic_work)
      
      expect(page).to have_link('Click here to resolve this problem', edit_curation_concern_generic_file_path(file))
      expect(page).to have_selector('.alert', text: 'It looks like there is a problem with some of your files:')
    end

    it 'should not show alert when there is content' do
      generic_file_with_content
      login_as user
      visit edit_curation_concern_generic_work_path(generic_work)
      
      expect(page).to_not have_selector('.alert', text: 'It looks like there is a problem with some of your files:')
    end
    it 'Viewing generic file without content' do
      login_as user
      visit curation_concern_generic_file_path(generic_file_without_content)
      
      expect(page).to have_selector('.alert', text: 'It looks like there was an issue uploading this file.')
      expect(page).to have_selector('td', text: 'File Not Found')
    end

    it 'Viewing generic file with content' do
      login_as user
      visit curation_concern_generic_file_path(generic_file_with_content)
      
      expect(page).to_not have_selector('.alert', text: 'It looks like there was an issue uploading this file.')
      expect(page).to have_selector('td', text: 'Filename: generic_file_spec.rb')
    end

    it 'editing generic file with empty content' do
      login_as user
      visit edit_curation_concern_generic_file_path(generic_file_without_content)
      
      expect(page).to have_selector('.alert', text: 'it looks like this file didn’t upload correctly.')
      expect(page).to have_selector('.alert', text: 'help@curate.org')
    end
  end

  context 'file rollback' do
    let(:user) { FactoryGirl.create(:user) }
    let(:curation_concern) { FactoryGirl.create(:generic_work, user: user) }
    let(:image_file_1) { File.join(fixture_path, 'files/image.png') }
    let(:image_file_2) { File.join(fixture_path, 'files/image_2.png') }

    before do
      curation_concern.save!
      login_as(user)
    end

    xit 'should change versions correctly', redundant: true do
      visit new_curation_concern_generic_file_path(curation_concern)

      within("form.new_generic_file") do
        fill_in("Title", with: 'Test Image')
        attach_file("Upload a file", image_file_1)
        click_on("Attach to Generic Work")
      end
      visit curation_concern_generic_work_path(curation_concern)
      generic_file = curation_concern.generic_files.first
      visit edit_curation_concern_generic_file_path(generic_file)
      within("form.edit_generic_file") do
        attach_file("Upload a file", image_file_2)
        click_on("Update Attached File")
      end

      visit curation_concern_generic_work_path(curation_concern)
      page.should have_link('image_2.png')
      page.should_not have_link('image.png')

      visit versions_curation_concern_generic_file_path(generic_file)
      within "form.edit_generic_file" do
        within '#generic_file_version' do
          find("option[value='content.0']").select_option
        end
        click_on 'Rollback to selected File'
      end

      visit curation_concern_generic_work_path(curation_concern)
      page.should_not have_link('image_2.png')
      page.should have_link('image.png')
    end
  end

  def upload_my_file(work, visibility)
    login_as another_user
    visit new_curation_concern_generic_file_path(work)
    uploaded_file = File.join(fixture_path, 'files/image.png')

    within("form.new_generic_file") do
      fill_in("Title", with: 'image.png')
      attach_file("Upload a file", uploaded_file)
      choose(visibility)
      click_on("Attach to Generic Work")
    end
  end

  def upload_file(work, file, visibility)
    login_as user
    visit new_curation_concern_generic_file_path(work)

    within("form.new_generic_file") do
      attach_file("Upload a file", file)
      choose(visibility)
      click_on("Attach to Generic Work")
    end
  end
end

describe 'Viewing a generic file that is private' do
  let(:user) { FactoryGirl.create(:user) }
  let(:work) { FactoryGirl.create(:private_generic_file, title: "Sample file" ) }

  it 'should show a stub indicating we have the work, but it is private' do
    login_as(user)
    visit curation_concern_generic_file_path(work)
    page.should have_content('Unauthorized')
    page.should have_content('The generic file you have tried to access is private')
    page.should have_content("ID: #{work.pid}")
    page.should_not have_content("Sample file")
  end
end

