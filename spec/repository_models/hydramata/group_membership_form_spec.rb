require 'spec_helper'

describe Hydramata::GroupMembershipForm do


  let!(:person_1) { FactoryGirl.create(:person_with_user) }
  let!(:person_2) { FactoryGirl.create(:person_with_user) }
  let(:user_1) { person_1.user }
  let(:user_2) { person_2.user }
  let!(:group) { FactoryGirl.create(:group, user: user_1) }

  let(:params_1) {
    { group_id: group.pid, title: "Title 1", description: "Description for Title 1", members: members_to_add }
  }

  let(:params_2) {
    { group_id: group.pid, title: "Title 2", description: "Description for Title 2", members: members_to_remove }
  }

  let(:params_3) {
    { group_id: group.pid, title: "Title 2", description: "Description for Title 2", members: members_with_changed_permission }
  }

  let(:params_4) {
    { group_id: group.pid, title: "Title 2", description: "Description for Title 2", members: members_with_no_editors, no_editors: true }
  }

  let(:params_5) {
    { group_id: group.pid, title: "Title 1", description: "Description for Title 1", members: remove_member_and_add_them_back }
  }

  let(:members_to_add) {
    [
      { person_id: person_1.pid, action: "create", role: "manager" },
      { person_id: person_2.pid, action: "create", role: "member" }
    ]
  }

  let(:members_to_remove) {
    [
      { person_id: person_1.pid, action: "none", role: "manager" },
      { person_id: person_2.pid, action: "destroy", role: "member" }
    ]
  }

  let(:members_with_changed_permission) {
    [
      { person_id: person_2.pid, action: "none", role: "manager" }
    ]
  }

  let(:members_with_no_editors) {
    [
      { person_id: person_1.pid, action: "create", role: "member" },
      { person_id: person_2.pid, action: "none", role: "member" }
    ]
  }

  let(:remove_member_and_add_them_back) {
    [
      { person_id: person_2.pid, action: "destroy", role: "member" },
      { person_id: person_1.pid, action: "none", role: "manager" },
      { person_id: person_2.pid, action: "create", role: "member" }
    ]
  }
  context '#save' do

    before(:each) do
      @gmf = Hydramata::GroupMembershipForm.new(params_1)
    end

    it 'should append the member to the group' do
      group.members.should == []
      @gmf.save
      group = Hydramata::Group.find(@gmf.group.pid)
      group.members.should == [person_1, person_2]
    end

    it 'should remove member from the group' do
      @gmf.save
      group = Hydramata::Group.find(@gmf.group.pid)
      group.members.should == [person_1, person_2]

      @gmf_remove = Hydramata::GroupMembershipForm.new(params_2)
      @gmf_remove.save
      group = Hydramata::Group.find(@gmf_remove.group.pid)
      group.members.should == [person_1]
      @gmf.group.pid.should == @gmf_remove.group.pid
    end

    it 'should change group permission for the member' do
      @gmf.save
      group = Hydramata::Group.find(@gmf.group.pid)
      group.members.should == [person_1, person_2]
      group.edit_users.size.should == 1
      group.read_users.size.should == 1

      @gmf_change_perm = Hydramata::GroupMembershipForm.new(params_3)
      @gmf_change_perm.save
      group = Hydramata::Group.find(@gmf_change_perm.group.pid)
      group.members.should == [person_1, person_2]
      group.edit_users.size.should == 2
      group.read_users.size.should == 0

      @gmf.group.pid.should == @gmf_change_perm.group.pid
    end

    it 'should have atleast one editor' do
      @gmf = Hydramata::GroupMembershipForm.new(params_4)
      @gmf.save.should == false
    end

    it 'should add back member which was deleted in the same update' do
      @gmf.save
      group = Hydramata::Group.find(@gmf.group.pid)
      group.members.should == [person_1, person_2]

      @gmf_update = Hydramata::GroupMembershipForm.new(params_5)
      @gmf_update.save

      group = Hydramata::Group.find(@gmf_update.group.pid)

      group.members.should == [person_1, person_2]
      @gmf.group.pid.should == @gmf_update.group.pid
    end
  end

end
