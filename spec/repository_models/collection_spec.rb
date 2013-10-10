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

  it '#to_solr' do
    subject.to_solr['human_readable_type_sim'].should == ['Collection']
    subject.to_solr['resource_type'].should be_nil
  end

end

