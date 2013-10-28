require 'spec_helper'

describe "select representative file for work" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:file1){ FactoryGirl.create(:generic_file, title: ["Sample file 1"] ) }
  let!(:file2){ FactoryGirl.create(:generic_file, title: ["Sample file 2"] ) }
  let!(:work1) { FactoryGirl.create(:generic_work, user: user, title: 'Work 1' ) }
  
  context "when a file is selected from the dropbox and saved" do
    it "should be persisted" do
      login_as(user)
      work1.representative.should == nil

      work1.generic_files << file1
      work1.generic_files << file2

      visit edit_curation_concern_generic_work_path(work1)
      select file2.title.first, from: "generic_work[representative]"
      select "All rights reserved", from: "generic_work[rights]"
      click_button "Update Generic work"

      reload = GenericWork.find(work1.pid)
      reload.representative.should == file2.pid
    end
  end
end
