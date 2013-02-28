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
end
