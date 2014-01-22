require 'spec_helper'

describe Organization do
  let(:organization) { Organization.new}
  let(:person) { FactoryGirl.create(:person)}

  describe '#human_readable_type' do
    it "indicates organization" do
      organization.human_readable_type.should == 'Organization'
    end
  end

  describe '#add_member' do
    it 'should be able to add people' do
      expect( organization.members ).to eq([])
      organization.add_member(person).should be_true
      expect( organization.members ).to include(person)
    end

    it 'should not add if collectible is not a person' do
      expect( organization.members ).to eq([])
      work = FactoryGirl.create(:generic_work)
      organization.add_member(work).should be_false
      expect( organization.members ).to eq([])
    end

    it 'should handle attempt to add nil' do
      expect( organization.members ).to eq([])
      organization.add_member(nil).should be_false
      expect( organization.members ).to eq([])
    end
  end

  describe '#remove_member' do
    it 'should be able to remove people' do
      organization.add_member(person)
      expect( organization.members ).to include(person)
      organization.remove_member(person).should be_true
      expect( organization.members ).to eq([])
    end

    it 'should handle attempt to remove person who is not in organization' do
      organization.add_member(person)
      expect( organization.members ).to include(person)
      another_person = FactoryGirl.create(:person)
      organization.remove_member(another_person).should be_false
      expect( organization.members ).to include(person)
    end

    it 'should handle attempt to remove nil' do
      organization.add_member(person)
      expect( organization.members ).to include(person)
      organization.remove_member(nil).should be_false
      expect( organization.members ).to include(person)
    end
  end

end
