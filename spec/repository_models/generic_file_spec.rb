require 'spec_helper'
describe GenericFile do
  subject { GenericFile.new }

  include_examples 'with_access_rights'
  include_examples 'is_embargoable'

  it { should respond_to(:versions) }
  it { should respond_to(:human_readable_type) }
  it { should respond_to(:current_version_id) }
  it { should respond_to(:file=) }
  it { should respond_to(:filename) }
  it { should respond_to(:visibility) }
  it { should respond_to(:visibility=) }

  it 'has a #human_readable_short_description' do
    subject.human_readable_short_description.length.should_not == 0
  end

  it 'has a .human_readable_short_description' do
    subject.class.human_readable_short_description.length.should_not == 0
  end

  it 'uses #noid for #to_param' do
    subject.to_param.should == subject.noid
  end

  it 'has no title to display' do
    subject.to_s.should == "No Title"
  end

  let(:user) { FactoryGirl.create(:user) }
  let(:file) { Rack::Test::UploadedFile.new(__FILE__, 'text/plain', false) }
  let(:persisted_generic_file) {
    FactoryGirl.create_generic_file(:mock_curation_concern, user, file)
  }

  it 'has a current version id' do
    persisted_generic_file.current_version_id.should == "content.0"
  end

  it 'has file_name as its title to display' do
    expect(persisted_generic_file.to_s).to eq(File.basename(__FILE__))
  end

end
