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
      subject.visibility.should == Sufia::Models::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end
    it "should have visibility writer" do
      subject.visibility = Sufia::Models::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      subject.should be_open_access
    end
  end

end
