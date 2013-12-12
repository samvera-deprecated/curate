require 'spec_helper'

describe GenericFile do
  subject { GenericFile.new }

  it_behaves_like 'with_access_rights'
  it_behaves_like 'is_embargoable'

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
    subject.stub(:persisted?).and_return(true)
    subject.to_param.should == subject.noid
  end

  it 'has no title to display' do
    subject.to_s.should == "No Title"
  end

  let(:user) { FactoryGirl.create(:user) }
  let(:file) { Rack::Test::UploadedFile.new(__FILE__, 'text/plain', false) }
  let(:persisted_generic_file) {
    FactoryGirl.create_generic_file(:generic_work, user, file)
  }

  it 'has a current version id' do
    persisted_generic_file.current_version_id.should == "content.0"
  end

  it 'has file_name as its title to display' do
    expect(persisted_generic_file.to_s).to eq(File.basename(__FILE__))
  end

  context '#latest_version' do
    subject { described_class.new.latest_version }
    it { should respond_to :created_on }
    it { should respond_to :committer_name }
    it { should respond_to :formatted_created_on }
    it { should respond_to :version_id }
  end

  context '#copy_permissions_from' do
    let(:work){ FactoryGirl.create(:public_generic_work) }
    let(:file) { FactoryGirl.create(:generic_file) }

    it 'should copy permissions from the given work' do
      file.visibility.should_not == "open"
      file.copy_permissions_from(work)
      file.visibility.should == "open"
    end
  end

end
