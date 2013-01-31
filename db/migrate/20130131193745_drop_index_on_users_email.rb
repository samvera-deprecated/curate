class DropIndexOnUsersEmail < ActiveRecord::Migration
  def up
    remove_index :users, :email
    add_index :users, :email, unique: false
  end

  def down
  end
end
