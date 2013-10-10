require 'spec_helper'

describe Collection do
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
      before { subject.human_readable_type = 'Profile' } 
      it "should have field" do
        solr_doc['human_readable_type_sim'].should == ['Profile']
        solr_doc['generic_type_sim'].should == ['Collection']
      end
    end
    describe "when profile isn't set" do
      it "should have field" do
        solr_doc['human_readable_type_sim'].should == ['Collection']
        solr_doc['generic_type_sim'].should == ['Collection']
      end
    end
  end

end
