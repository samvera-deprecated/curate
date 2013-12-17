require 'spec_helper.rb'

describe 'curation_concern/base/_thumbnail.html.erb' do
  describe 'with an image file' do
    it 'displays a thumbnail' do
      img = stub_model(GenericFile, image?: true, pid: 'curate:foo1')

      render(partial: 'thumbnail', locals: {thumbnail: img})

      expect(rendered).to include(download_path(img, {datastream_id: 'thumbnail'}))
    end
  end

  describe 'with an audio file' do
    it 'displays a generic image' do
      audio_file = stub_model(GenericFile, audit_stat: true, pid: 'curate:foo1', audio?: true)

      render(partial: 'thumbnail', locals: {thumbnail: audio_file})

      expect(rendered).to include(curation_concern_generic_file_path(audio_file.noid))
    end
  end

  describe 'with a video file'
end


