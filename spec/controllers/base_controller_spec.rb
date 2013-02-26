require 'spec_helper'

describe CurationConcern::BaseController do
  it 'should have #accept_contributor_agreement_accepting_value' do
    subject.accept_contributor_agreement_accepting_value.should == 'accept'
    subject._helper_methods.should include(:accept_contributor_agreement_accepting_value)
  end

  it 'should have #curation_concern exposed' do
    subject._helper_methods.should include(:curation_concern)
  end

  it 'has #contributor_agreement' do
    subject._helper_methods.should include(:contributor_agreement)
  end
end