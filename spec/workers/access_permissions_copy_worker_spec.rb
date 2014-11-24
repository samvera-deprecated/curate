require 'spec_helper'

describe AccessPermissionsCopyWorker do

  let(:person) { FactoryGirl.create(:person_with_user) }
  let(:user) { person.user }
  let(:another_person) { FactoryGirl.create(:person_with_user) }
  let(:another_user) { another_person.user }
  let(:group_1) { FactoryGirl.create(:group) }
  let(:group_2) { FactoryGirl.create(:group) }
  let(:generic_work) { FactoryGirl.create(:generic_work, user: user ) }
  let(:file) { Rack::Test::UploadedFile.new(__FILE__, 'text/plain', false) }
  let(:generic_file_1) { FactoryGirl.create_generic_file(:generic_work, user, file) } 
  let(:generic_file_2) { FactoryGirl.create_generic_file(:generic_work, user, file) } 

  it 'should raise error when no pid' do
    expect{
      AccessPermissionsCopyWorker.new(nil)
    }.to raise_error( AccessPermissionsCopyWorker::PidError )
  end

  context 'for valid pid' do
    before(:each) do
      generic_work.add_editor_group(group_1)
      generic_work.add_editor_group(group_2)

      generic_work.add_editor(another_user)

      generic_work.generic_files = [generic_file_1, generic_file_2]

      generic_work.save
    end

    it 'should apply group/editors permissions to attached files' do
      expect(generic_file_1.reload.edit_groups).to be_empty
      expect(generic_file_2.reload.edit_groups).to be_empty

      expect(generic_work.generic_files).to eq [generic_file_1, generic_file_2]
      expect(generic_work.edit_users).to eq [user.user_key, another_user.user_key]

      expect(generic_file_1.edit_users).to eq [user.user_key]
      expect(generic_file_2.edit_users).to eq [user.user_key]

      AccessPermissionsCopyWorker.new(generic_work.pid).run

      generic_file_1.reload.edit_groups.should == [group_1.pid, group_2.pid]
      generic_file_2.reload.edit_groups.should == [group_1.pid, group_2.pid]

      expect(generic_file_1.edit_users).to eq [user.user_key, another_user.user_key]
      expect(generic_file_2.edit_users).to eq [user.user_key, another_user.user_key]
    end
  end
end
