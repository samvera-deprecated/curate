require 'spec_helper'

describe Curate::User do

  it 'should create a person when a user is created' do
    new_user = FactoryGirl.build(:user, email: "test.user@example.com")
    new_user.save!
    new_user.person.class.should == Person
  end

end
