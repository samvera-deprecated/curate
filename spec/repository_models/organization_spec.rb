require 'spec_helper'

describe Organization do
  let(:organization) { Organization.new}
  let(:person) { FactoryGirl.create(:person)}
  let(:another_person) { FactoryGirl.create(:person)}
  let(:work) { FactoryGirl.create(:generic_work)}

  describe 'add_member' do
    it 'should be able to add people' do
      expect( organization.members ).to eq([])
      organization.add_member(person)
      expect( organization.members ).to include(person)
    end

    it 'should not add if collectible is not a person' do
      expect( organization.members ).to eq([])
      organization.add_member(work)
      expect( organization.members ).to eq([])
    end

    it 'should handle attempt to add nil' do
      expect( organization.members ).to eq([])
      organization.add_member(nil)
      expect( organization.members ).to eq([])
    end
  end

  describe 'remove_member' do
    it 'should be able to remove people' do
      organization.add_member(person)
      expect( organization.members ).to include(person)
      organization.remove_member(person)
      expect( organization.members ).to eq([])
    end

    it 'should handle attempt to remove person who is not in organization' do
      organization.add_member(person)
      expect( organization.members ).to include(person)
      organization.remove_member(another_person)
      expect( organization.members ).to include(person)
    end

    it 'should handle attempt to remove nil' do
      organization.add_member(person)
      expect( organization.members ).to include(person)
      organization.remove_member(nil)
      expect( organization.members ).to include(person)
    end
  end
end
