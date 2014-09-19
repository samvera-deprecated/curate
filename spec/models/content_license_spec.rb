require 'spec_helper'

describe ContentLicense do
  let(:content_license_for_approved_user) { ContentLicense.new(user2) }
  let(:content_license_for_user) { ContentLicense.new(user1) }
  let(:user1) { FactoryGirl.create(:person_with_user) }
  let(:user2) { FactoryGirl.create(:person_with_user) }

  let(:license_permission) { { "open" => "license_group_id"} }

  it 'does not have permission to change license' do
    content_license_for_user.is_permitted?(license_permission).should == false
  end

  it 'does have permission to change license' do
    user2.stub(:groups){ ["license_group_id"] }
    content_license_for_approved_user.is_permitted?(license_permission).should == true
  end

end
