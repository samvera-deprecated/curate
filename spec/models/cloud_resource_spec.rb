require 'spec_helper'

describe CloudResource do
  subject { CloudResource.new(curation_concern, user, params)}

  let(:curation_concern) { GenericWork.new }
  let(:user) { User.new }
  let(:params)  { {} }

  it 'has param key' do
    subject.param_key.should == :selected_files
  end

  describe 'process cloud resource' do

  end

  describe CloudResource::DownloadResource do
    subject { CloudResource::DownloadResource.new(specification)}
    let(:file) { curate_fixture_file_upload('files/image.png', 'image/png') }
    let(:provider) {"https://dl.dropboxusercontent.com"}
    let(:specification) { {"url"=>"https://dl.dropboxusercontent.com/1/view/ndhjx597auktpnz/Week%203%20Notes.pdf", "expires"=>"nil"} }

    it 'has url_key' do
      subject.url_key.should == :url
    end

    it 'has header_key' do
      subject.header_key.should == :auth_header
    end

    it 'has expire_key' do
      subject.expire_key.should == :expires
    end

    describe '#download_content_from_host' do
      it 'create download path for a local file' do
      end

      it 'create download path for a cloud file' do
        expect(subject.download_content_from_host).to be_kind_of(String)
      end
    end
  end

end

