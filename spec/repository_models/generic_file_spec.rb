require 'spec_helper'
describe GenericFile do
  subject { GenericFile.new }

  it { should respond_to(:versions) }
  it { should respond_to(:current_version_id) }
  it { should respond_to(:revised_file=) }
  it { should respond_to(:display_title) }

  it 'uses #noid for #to_param' do
    subject.to_param.should == subject.noid
  end

  let(:user) { FactoryGirl.create(:user) }
  let(:persisted_generic_file) {
    FactoryGirl.create_generic_file(:senior_thesis, user)
  }
  it 'has a current version id' do
    persisted_generic_file.current_version_id.should == "content.0"
  end
end
