require 'spec_helper'

describe Person do


  describe 'Profile' do

    context '#create_profile', with_callbacks: true do
      let(:name) { "Bilbo Baggins" }
      let(:user) { FactoryGirl.create(:user, name: name) }
      let(:person) { user.person }

      it 'creates a profile with class Collection' do
        person.create_profile(user)
        person = Person.find(user.repository_id)
        profile = person.profile

        expect(profile).to be_kind_of Collection
        expect(profile.depositor).to eq(user.to_s)
        expect(profile.title).to eq "My Profile"
        expect(profile.read_groups).to eq([Sufia::Models::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC])
      end

    end

  end

end
