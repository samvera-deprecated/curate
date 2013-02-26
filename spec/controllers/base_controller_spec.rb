require 'spec_helper'

describe CurationConcern::BaseController do
  it 'should have #accepted_contributor_agreement_value' do
    subject.accepted_contributor_agreement_value.should == 'accept'
    subject._helper_methods.should include(:accepted_contributor_agreement_value)
  end

  it 'should have #curation_concern exposed' do
    subject._helper_methods.should include(:curation_concern)
  end
end