require 'spec_helper'

describe CurationConcern::BaseController do
  it 'should have #curation_concern exposed' do
    subject._helper_methods.should include(:curation_concern)
  end

  it 'has #contributor_agreement' do
    subject._helper_methods.should include(:contributor_agreement)
  end

  it 'has #cloud_resources_to_ingest' do
    subject._helper_methods.should include(:cloud_resources_to_ingest)
  end

end
