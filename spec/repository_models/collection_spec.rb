require 'spec_helper'

describe Collection do
  subject { FactoryGirl.create(:collection) }
  let(:another_collection){ FactoryGirl.create(:collection) }

  it 'can contain another collection' do
    subject.members << another_collection
    subject.members.should == [another_collection]
  end

  it 'cannot contain itself' do
    subject.members << subject
    subject.save
    subject.reload
    subject.members.should == []
  end

end

