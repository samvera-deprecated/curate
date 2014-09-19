require 'spec_helper'
describe Hydramata::GroupsController do
  let(:person) { FactoryGirl.create(:person_with_user) }
  let(:user) { person.user }
  let(:another_person) { FactoryGirl.create(:person_with_user) }
  let(:another_user) { another_person.user }
  before { sign_in user }

  describe "#new" do
    it 'renders the form' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe "#create" do
    let(:hydramata_group) {
       { "title" => "New Group", "description" => "New Desc",
         "members_attributes" => { "0" => { "id" => person.pid, "_destroy" => ""},
                                   "1" => { "id" => "", "_destroy" => "", "name" => ""}
                                 }
       }
    }
    let(:group_member) {
        { "edit_users_ids" => [ person.pid ] }
    }

    it "should be successful" do
      expect {
        post :create, hydramata_group: hydramata_group, group_member: group_member
      }.to change{Hydramata::Group.count}.by(1)
      expect(response).to redirect_to hydramata_groups_path
      expect(flash[:notice]).to eq 'Group created successfully.'
    end

    it "should handle failure" do
      expect {
        post :create, hydramata_group: hydramata_group, group_member: {}
      }.to change{Hydramata::Group.count}.by(0)
      expect(assigns(:group)).to be_an_instance_of Hydramata::Group
      expect(response).to render_template('new')
    end
  end

  let(:group) { FactoryGirl.create(:group, user: user, title: "Title 1", description: "Description 1") }

  describe "#destroy" do
    before do
      group.group_edit_membership(person)
      group.save!
    end
    it "should be successful" do
      delete :destroy, id: group.pid
      expect(response).to redirect_to catalog_index_path
      expect(flash[:notice]).to eq "Deleted #{group.title}"
    end
  end

  describe "#update" do
    let(:hydramata_group) {
       { "title" => "Group - 1", "description" => "Desc - 1",
         "members_attributes" => { "0" => { "id" => person.pid, "_destroy" => ""},
                                   "1" => { "id" => "", "_destroy" => "", "name" => ""}
                                 }
       }
    }
    let(:group_member) {
        { "edit_users_ids" => [ person.pid ] }
    }

    before(:each) do
      group.add_member(person, "manager")
    end

    it "updates title and description of the Group" do
      reload_group = Hydramata::Group.find(group.pid)
      reload_group.title.should_not == hydramata_group["title"]
      reload_group.description.should_not == hydramata_group["description"]

      put :update, id: group.pid, hydramata_group: hydramata_group, group_member: group_member
      expect(response).to redirect_to(hydramata_group_path(group))
      expect(flash[:notice]).to eq 'Group updated successfully.'

      reload_group = Hydramata::Group.find(group.pid)
      reload_group.title.should == hydramata_group["title"]
      reload_group.description.should == hydramata_group["description"]
    end

    it "handles failure" do
      reload_group = Hydramata::Group.find(group.pid)
      put :update, id: group.pid, hydramata_group: hydramata_group, group_member: {}
      expect(assigns(:group)).to be_an_instance_of Hydramata::Group
      expect(response).to render_template('edit')
      expect(flash[:error]).to eq 'Group was not updated.'
    end

    let(:another_hydramata_group) {
       { "title" => "Group - 1", "description" => "Desc - 1",
         "members_attributes" => { "0" => { "id" => person.pid, "_destroy" => ""},
                                   "1" => { "id" => another_person.pid},
                                   "2" => { "id" => "", "_destroy" => "", "name" => ""}
                                 }
       }
    }

    let(:another_group_member) {
        { "edit_users_ids" => [ person.pid ] }
    }

    it "adds a member to the group" do
      put :update, id: group.id, hydramata_group: another_hydramata_group, group_member: another_group_member
      expect(response).to redirect_to(hydramata_group_path(group))
      expect(flash[:notice]).to eq 'Group updated successfully.'

      reload_group = Hydramata::Group.find(group.pid)
      reload_group.edit_users.should == [ person.user_key ]
      reload_group.read_users.should == [ another_person.user_key ]

      reload_group.members.should == [ person, another_person ]
    end

    let(:delete_a_member) {
       { "title" => "Group - 1", "description" => "Desc - 1",
         "members_attributes" => { "0" => { "id" => person.pid, "_destroy" => ""},
                                   "1" => { "id" => another_person.pid, "_destroy" => "true"},
                                   "2" => { "id" => "", "_destroy" => "", "name" => ""}
                                 }
       }
    }

    it "removes a member from the group" do
      group.add_member(another_person, "member")

      group.reload.edit_users.should == [ person.user_key ]
      group.reload.read_users.should == [ another_person.user_key ]
      group.reload.members.should == [ person, another_person ]

      put :update, id: group.id, hydramata_group: delete_a_member, group_member: another_group_member
      expect(response).to redirect_to(hydramata_group_path(group))
      expect(flash[:notice]).to eq 'Group updated successfully.'

      reload_group = Hydramata::Group.find(group.pid)
      reload_group.edit_users.should == [ person.user_key ]
      reload_group.read_users.should == []

      reload_group.members.should == [ person ]
    end

    it 'should have atleast one editor' do
      put :update, id: group.id, hydramata_group: another_hydramata_group, group_member: {}
      expect(response).to render_template(:edit)
      expect(flash[:error]).to eq 'Group was not updated.'
    end
  end
end
