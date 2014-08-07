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

    describe '#download_content_from_host cloud' do
      it 'creates download path for a cloud file' do
        # An object used for stubbing the HTTParty get method's return.
        response = Net::HTTPResponse.new("1.1", 200, "OK")
        response.content_type="image/jpeg"
        HTTParty.stub(:get).and_return(response)
        # Mock the file open and read, too
        file = double(File)
        File.stub(:open).and_return(file)
        expect(subject.download_content_from_host).to be_instance_of(String)
      end
    end

    describe '#download_content_from_host local' do
      subject { CloudResource::DownloadResource.new(specification)}
      let(:file) { curate_fixture_file_upload('files/image.png', 'image/png') }
      let(:provider) {"file:///"}
      let(:specification) { {"url"=>"file:///pathToFile", "expires"=>"nil"} }

      it 'createss a download path for a local file' do
        # Mock the file methods
        file = 'file'
        File.stub(:new).and_return(file)
        File.stub(:open).and_return(file)
        file.stub(:close)
        expect(subject.download_content_from_host).to be_instance_of(String)
      end
    end

    describe '#download_content_from_host nil' do
      subject { CloudResource::DownloadResource.new(specification)}
      let(:file) { curate_fixture_file_upload('files/image.png', 'image/png') }
      let(:provider) {"nil_test"}
      let(:specification) { {"url"=>"nil_test", "expires"=>"nil"} }

      it 'does not create a download path for a file' do
        # Mock the file methods
        file = 'file'
        File.stub(:new).and_return(file)
        File.stub(:open).and_return(file)
        expect(subject.download_content_from_host).to be_nil
      end
    end
    
  end


end

