require 'spec_helper'

describe CurationConcern::RelatedFilesController do
  before(:each) do
    sign_in(user)
  end
  let(:parent_curation_concern) {
    FactoryGirl.create_curation_concern(:senior_thesis, user)
  }
  let(:user) { FactoryGirl.create(:user) }
  it 'has a #parent_curation_concern' do
    controller.params[:parent_curation_concern_id] = parent_curation_concern.noid
    controller.parent_curation_concern.should == parent_curation_concern
  end

end
