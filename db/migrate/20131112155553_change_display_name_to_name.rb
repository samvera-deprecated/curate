class ChangeDisplayNameToName < ActiveRecord::Migration
  def change
    rename_column(:users, :display_name, :name)
    add_index(:users, :name)
  end
end
