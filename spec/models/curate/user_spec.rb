require 'spec_helper'

describe Curate::User do

  it 'should create a person when a user is created' do
    new_user = FactoryGirl.build(:user, email: "test.user@example.com")
    new_user.save!
    new_user.person.class.should == Person
    new_user.person.read_groups.should include(Sufia::Models::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC)
    new_user.person.edit_users.should include(new_user.user_key)
    new_user.person.depositor.should == new_user.user_key
  end

end
