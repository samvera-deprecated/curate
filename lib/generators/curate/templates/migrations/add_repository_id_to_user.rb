class AddRepositoryIdToUser < ActiveRecord::Migration
  def change
    add_column User.table_name, :repository_id, :string
    add_index User.table_name, :repository_id, unique: true
  end 
end
