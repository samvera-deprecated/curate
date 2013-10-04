require 'spec_helper'

describe 'display thumbnail' do
  let(:user) { FactoryGirl.create(:user) }
  let(:curation_concern) { FactoryGirl.create(:public_image, user: user) }
  let(:image_file) { File.open(Rails.root.join('../../spec/fixtures/files/image.png')) }
  let(:generic_file) { FactoryGirl.create(:generic_file, user: user) }

  context 'Display thumbnail for associated iamges' do
    before do
      generic_file.datastreams['thumbnail'].content = image_file
      generic_file.save!
      curation_concern.generic_files << generic_file
      curation_concern.save!
    end

    it 'shows thumbnail for all related files' do
      login_as(user)
      visit curation_concern_image_path(curation_concern)
      page.should have_css("img[src$='#{generic_file.pid}?datastream_id=thumbnail']")
    end
  end
end
