require 'spec_helper'

describe Group do

  let(:person) { FactoryGirl.create(:person_with_user)}
  let(:another_person) { FactoryGirl.create(:person_with_user)}
  let(:work) { FactoryGirl.create(:generic_work)}
  let(:test_group_1) { FactoryGirl.create(:group) }
  let(:test_group_2) { FactoryGirl.create(:group) }
  let(:test_group_3) { FactoryGirl.create(:group) }

  describe 'contains no members' do
    subject { FactoryGirl.create(:group) }
    its(:title) { should_not be_nil }
    its(:description) { should_not be_nil }
    it '#dates' do
      expect(subject.date_uploaded.to_s).to eq Date.today.to_s
      expect(subject.date_modified.to_s).to eq Date.today.to_s
    end
    its(:members) { should eq []}
  end

  describe '.add_member' do
    it 'should add members to the group with read permissions' do
      test_group_1.add_member(person)
      test_group_1.add_member(another_person)

      test_group_1.reload
      test_group_1.members.should == [person, another_person]
      test_group_1.members.count.should eq 2

      test_group_1.read_users.count.should == 2
      test_group_1.edit_users.count.should == 0 

      person.groups.count.should eq 1
      another_person.groups.count.should eq 1
    end

    it 'should add members to the group with edit permissions' do
      test_group_1.add_member(person, 'manager')
      test_group_1.add_member(another_person, 'manager')

      test_group_1.reload
      test_group_1.members.should == [person, another_person]
      test_group_1.members.count.should eq 2

      test_group_1.read_users.count.should == 0
      test_group_1.edit_users.count.should == 2

      person.groups.count.should eq 1
      another_person.groups.count.should eq 1
    end
  end

  describe '.remove_member' do
    it 'should work' do
      test_group_2.add_member(person)
      test_group_2.add_member(another_person)

      test_group_2.reload
      test_group_2.members.should == [person, another_person]

      test_group_2.remove_member(another_person)
      test_group_2.save!

      test_group_2.reload
      test_group_2.members.should include(person)
      test_group_2.members.should_not include(another_person)
      test_group_2.members.count.should eq 1

      another_person.groups.count.should eq 0
      person.groups.count.should eq 1

    end

    it 'should not remove member, who is the only editor' do
      test_group_3.add_member(person, 'manager')

      test_group_3.reload
      test_group_3.members.should == [person]

      test_group_3.edit_users.should == [person.user_key]
      test_group_3.edit_users.size.should == 1

      test_group_3.remove_member(person)

      test_group_3.reload
      test_group_3.edit_users.should == [person.user_key]
      test_group_3.edit_users.size.should == 1
    end
  end

  describe 'cannot add' do
    it 'a non-person object' do
      test_group_3.add_member(work)
      test_group_3.members.count.should eq 0
    end
  end

  describe '.can_be_member_of_collection' do
    it 'should indicate a group cannot be added to a collection' do
      group = Hydramata::Group.new
      expect(group.can_be_member_of_collection?(Collection.new)).to be_false
    end
  end

end
