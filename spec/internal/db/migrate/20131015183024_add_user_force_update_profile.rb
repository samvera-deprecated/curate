class AddUserForceUpdateProfile < ActiveRecord::Migration
  def change
    # Apologies for the negative boolean; However with a default column value of
    # true, ActiveRecord was setting the default field value to false.
    # So to appease the ORM, you get the lovely negative boolean!
    add_column User.table_name, :user_does_not_require_profile_update, :boolean, default: false
  end
end
