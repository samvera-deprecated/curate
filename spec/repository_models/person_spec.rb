require 'spec_helper'

describe Person do


  describe 'Profile' do

    context '#create_profile' do
      let(:name) { "Bilbo Baggins" }
      let(:user) { FactoryGirl.create(:user, name: name) }
      let(:person) { user.person }

      it 'creates a profile with class Collection' do
        person.create_profile(user)
        person = Person.find(user.repository_id)    # reload
        person.profile.class.should == Collection
      end

      it 'sets depositor metadata' do
        person.create_profile(user)
        person.profile.depositor.should == user.to_s
      end

      it 'sets the title of the profile' do
        person.create_profile(user)
        person.profile.title.should == "My Profile"
      end

      it 'has public visibility by default' do
        profile = person.create_profile(user)
        profile.read_groups.should == [Sufia::Models::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC]
      end
    end

  end

end
