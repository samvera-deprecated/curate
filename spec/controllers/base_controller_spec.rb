require 'spec_helper'

describe CurationConcern::BaseController do
  it 'should have #curation_concern exposed' do
    subject._helper_methods.should include(:curation_concern)
  end

  it 'has #contributor_agreement' do
    subject._helper_methods.should include(:contributor_agreement)
  end
end