class AddUserForceUpdateProfile < ActiveRecord::Migration
  def change
    add_column User.table_name, :force_update_profile, :boolean, default: true
  end
end
