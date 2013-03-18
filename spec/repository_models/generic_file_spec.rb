require 'spec_helper'
describe GenericFile do
  subject { GenericFile.new }

  it { should respond_to(:versions) }
  it { should respond_to(:human_readable_type) }
  it { should respond_to(:current_version_id) }
  it { should respond_to(:file=) }
  it { should respond_to(:filename) }
  it { should respond_to(:visibility) }
  it { should respond_to(:visibility=) }

  it 'uses #noid for #to_param' do
    subject.to_param.should == subject.noid
  end

  it 'has no title to display' do
    subject.to_s.should == "No Title"
  end

  let(:user) { FactoryGirl.create(:user) }
  let(:persisted_generic_file) {
    FactoryGirl.create_generic_file(:senior_thesis, user)
  }

  it 'has a current version id' do
    persisted_generic_file.current_version_id.should == "content.0"
  end

  it 'has file_name as its title to display' do
    persisted_generic_file.to_s.should_not == "No Title"
  end


end
