require 'spec_helper'

describe CurationConcern::BaseActor do
  let(:user) { User.new }
  let(:curation_concern) { GenericFile.new }
  let(:attributes) { {visibility: visibility} }
  let(:visibility) { nil }
  subject { CurationConcern.actor(curation_concern, user, attributes)}
  describe 'with visibility "1"' do
    let(:visibility) { "1" }
    it 'should have visibility' do
      subject.send(:visibility).should == visibility
    end
    it 'should have visibility' do
      subject.send(:visibility_may_have_changed?).should == true
    end

  end
  describe 'with missing visibility' do
    let(:visibility) { nil }
    it 'should have visibility' do
      subject.send(:visibility).should be_nil
    end
    it 'should have visibility' do
      subject.send(:visibility_may_have_changed?).should == false
    end
  end
end
