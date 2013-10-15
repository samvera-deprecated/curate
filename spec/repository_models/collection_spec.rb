require 'spec_helper'

describe Collection do
  let(:reloaded_subject) { Collection.find(subject.pid) }

  it 'can contain another collection' do
    another_collection = FactoryGirl.create(:collection)
    subject.members << another_collection
    subject.members.should == [another_collection]
  end

  it 'cannot contain itself' do
    subject.members << subject
    subject.save
    reloaded_subject.members.should == []
  end

  describe "when visibility is private" do
    it "should not be open_access?" do
      subject.should_not be_open_access
    end
    it "should not be authenticated_only_access?" do
      subject.should_not be_authenticated_only_access
    end
    it "should not be private_access?" do
      subject.should be_private_access
    end
  end

  describe "visibility" do
    it "should have visibility accessor" do
      subject.visibility.should == Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end
    it "should have visibility writer" do
      subject.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      subject.should be_open_access
    end
  end

  describe "to_solr on a saved object" do
    before {subject.save(validate: false)}
    let(:solr_doc) {subject.to_solr}

    describe "when profile is set" do
      before { subject.resource_type = 'Profile' }
      it "should have field" do
       solr_doc['desc_metadata__resource_type_sim'].should == [subject.human_readable_type]
       solr_doc['desc_metadata__resource_type_tesim'].should == [subject.human_readable_type]
       solr_doc['generic_type_sim'].should == ['Collection']
      end
    end
    describe "when profile isn't set" do
      it "should have field" do
       solr_doc['desc_metadata__resource_type_sim'].should == [subject.human_readable_type]
       solr_doc['desc_metadata__resource_type_tesim'].should == [subject.human_readable_type]
       solr_doc['generic_type_sim'].should == ['Collection']
      end
    end
  end

  describe '#human_readable_type' do
    context "when profile is set" do
      it "indicates profile" do
        subject.resource_type = 'Profile'
        subject.save(validate: false)
        subject.human_readable_type.should == 'Profile'
      end
    end

    context "when profile isn't set" do
      it "indicates collection" do
        subject.human_readable_type.should == 'Collection'
      end
    end
  end

  describe '#add_member' do
    it 'adds the member to the collection and returns true' do
      work = FactoryGirl.create(:generic_work)
      subject.add_member(work).should be_true
      reloaded_subject.members.should == [work]
    end

    it 'returns false if there is nothing to add' do
      subject.add_member(nil).should be_false
    end

    it 'returns false if it failed to save' do
      subject.save
      work = FactoryGirl.create(:generic_work)
      subject.should_receive(:save).and_return(false)
      subject.add_member(work).should be_false
      reloaded_subject.members.should == []
    end
  end
end

