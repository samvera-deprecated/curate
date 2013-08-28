require 'spec_helper'

describe Person do

  let(:user){
    FactoryGirl.create(:user)
  }

  describe '.find_or_create_by_user' do
    it 'should create a new person object' do 
      obtained_result = Person.find_or_create_by_user(user)
      obtained_result.class.should eq Person
    end
  end
end
