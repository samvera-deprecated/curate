require 'spec_helper'

describe Curate::User do

  it 'should create a new person object when a new user is created' do
    new_user = FactoryGirl.build(:user, email: "test.user@example.com")
    new_user.person.should == nil
    new_user.save!
    new_user.person.class.should == Person
  end

  it 'should save person object when user is saved' do
    user = FactoryGirl.create(:user, email: "old@example.com")
    user.person.should_receive(:save).and_return(true)
    user.email = "new@example.com"
    user.save!
  end

end
