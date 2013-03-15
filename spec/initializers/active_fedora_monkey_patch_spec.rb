require 'spec_helper'

describe 'active fedora monkey patches' do
  let(:user) { FactoryGirl.create(:user) }
  let(:senior_thesis) { FactoryGirl.create_curation_concern(:senior_thesis, user) }
  let(:generic_file) { FactoryGirl.create_generic_file(senior_thesis, user) }
  it 'cannot delete' do
    senior_thesis_pid = senior_thesis.pid
    generic_file_pid = generic_file.pid

    content_datastream_url = generic_file.datastreams['content'].url
    datastream_url = content_datastream_url.split("/")[0..-2].join("/")
    senior_thesis.destroy

    # Why is this not ActiveFedora::ActiveObjectNotFoundError?
    # Because I am access the Fedora API, not using the ActiveFedora behavior
    expect {
      generic_file.inner_object.repository.client["#{datastream_url}?format=xml"].get
    }.to raise_error(RestClient::Unauthorized)

    expect {
      SeniorThesis.find(senior_thesis_pid)
    }.to raise_error(ActiveFedora::ActiveObjectNotFoundError)

    expect {
      GenericFile.find(generic_file_pid)
    }.to raise_error(ActiveFedora::ActiveObjectNotFoundError)

    expect(ActiveFedora::Base.exists?(senior_thesis_pid)).to eq(true)
    expect(ActiveFedora::Base.exists?(generic_file_pid)).to eq(true)
  end

end