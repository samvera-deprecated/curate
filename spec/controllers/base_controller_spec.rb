require 'spec_helper'

describe CurationConcern::BaseController do
  it 'should have #create_and_add_related_files_submit_value' do
    subject._helper_methods.should include(:create_and_add_related_files_submit_value)
  end
  it 'should have #curation_concern exposed' do
    subject._helper_methods.should include(:curation_concern)
  end

  it 'has #contributor_agreement' do
    subject._helper_methods.should include(:contributor_agreement)
  end
end