require 'spec_helper'

describe VisibilityCopyWorker do

  let(:work) { FactoryGirl.create(:work_with_files, visibility: Sufia::Models::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
  subject { VisibilityCopyWorker.new(work.id) }

  it "should have no content at the outset" do
    work.generic_files.first.visibility.should == 'psu'
  end

  it "should create a content datastream" do
    work.visibility.should == 'open'
    subject.run
    work.reload
    work.generic_files.each do |file|
      file.visibility.should == 'open'
    end
  end
end
