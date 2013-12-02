require 'spec_helper'

describe 'display thumbnail' do
  let(:user) { FactoryGirl.create(:user) }
  let(:curation_concern) { FactoryGirl.create(:public_image, user: user) }
  let(:image_file) { File.open(Rails.root.join('../../spec/fixtures/files/image.png')) }
  let(:generic_file1) { FactoryGirl.create(:generic_file, user: user) }
  let(:generic_file2) { FactoryGirl.create(:generic_file, user: user) }

  context 'Display thumbnail for associated iamges' do
    before do
      generic_file2.datastreams['thumbnail'].content = image_file
      generic_file2.mime_type = 'image/png'
      generic_file2.save!
      curation_concern.generic_files << generic_file2
      curation_concern.save!
    end

    it 'shows thumbnail for all related files' do
      login_as(user)
      visit curation_concern_image_path(curation_concern)
      page.should have_css("img[src$='#{generic_file2.to_param}?datastream_id=thumbnail'][class$='thumbnail']")
    end
  end

  context 'File Representative:' do
    before do
      generic_file1.datastreams['thumbnail'].content = image_file
      generic_file1.mime_type = 'image/png'
      generic_file1.save!
      generic_file2.datastreams['thumbnail'].content = image_file
      generic_file2.mime_type = 'image/png'
      generic_file2.save!
      curation_concern.generic_files << generic_file1
      curation_concern.generic_files << generic_file2
      curation_concern.representative = generic_file1.pid
      curation_concern.save!
    end
    it 'should show thumbnail when a representative is selected for the work' do
      login_as(user)
      visit curation_concern_image_path(curation_concern)
      page.should have_css("img[src$='#{generic_file1.to_param}?datastream_id=thumbnail'][class$='representative_image']")
      page.should have_css("img[src$='#{generic_file1.to_param}?datastream_id=thumbnail'][class$='thumbnail']")
      page.should have_css("img[src$='#{generic_file2.to_param}?datastream_id=thumbnail'][class$='thumbnail']")
      page.should_not have_css("img[src$='#{generic_file2.to_param}?datastream_id=thumbnail'][class$='representative_image']")
    end
  end
end
