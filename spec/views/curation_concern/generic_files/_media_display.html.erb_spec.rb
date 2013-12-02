require 'spec_helper.rb'

describe 'curation_concern/generic_files/_media_display.html.erb' do
  describe 'with an image file' do
    it 'displays the image' do
      img = stub_model(GenericFile, image?: true, pid: 'curate:testfoo')

      render(partial: 'media_display', locals: {generic_file: img})

      expect(rendered).to include(download_path(img))
    end
  end

  describe 'with an audio file' do
    it 'displays an audio player' do
      audio_file = stub_model(GenericFile, audio?: true, pid: 'curate:testfoo')

      render(partial: 'media_display', locals: {generic_file: audio_file})

      expect(rendered).to include('audio')
    end
  end

  describe 'with an unknown file' do
    it 'displays a placeholder image' do
      unknown_file = stub_model(GenericFile, pid: 'curate:testfoo')

      render(partial: 'media_display', locals: {generic_file: unknown_file})

      expect(rendered).to include('nope.png')
    end
  end
end

