# This migration comes from curate_engine (originally 20130723143059)
class AddUserForceUpdateProfile < ActiveRecord::Migration
  def change
    add_column User.table_name, :user_does_not_require_profile_update, :boolean, default: false
  end
end
