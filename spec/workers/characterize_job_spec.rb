require 'spec_helper'

describe CharacterizeJob do

  # I'm not entirely certain where I want to put this. Given that it is
  # leaning on an actor, I'd like to put it there. But actors are going to
  # push to a queue, so it is the worker that should choke.
  describe '#run' do
    let(:user) { FactoryGirl.create(:user) }
    let(:image_file) {
      Rack::Test::UploadedFile.new(
        File.expand_path('../../fixtures/files/image.png', __FILE__),
        'image/png',
        false
      )
    }
    let(:generic_file) {
      FactoryGirl.create_generic_file(:generic_work, user, image_file)
    }
    subject { CharacterizeJob.new(generic_file.pid) }

    it 'deletes the generic file when I upload a virus' do
      EnvironmentOverride.with_anti_virus_scanner(false) do
        expect {
          subject.run
        }.to raise_error(AntiVirusScanner::VirusDetected)
      end
    end

    it 'should create a thumbnail' do
      GenericFile.any_instance.stub(:image?).and_return(true)
      GenericFile.any_instance.stub(:mime_type).and_return('image/png')
      expect {
        subject.run
      }.to change { generic_file.reload.datastreams['thumbnail'].mimeType }.from(nil).to('image/png')
    end

  end
end