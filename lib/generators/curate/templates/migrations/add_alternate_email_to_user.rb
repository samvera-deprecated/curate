class AddAlternateEmailToUser < ActiveRecord::Migration
  def change
    add_column User.table_name, :alternate_email, :string
    add_index User.table_name, :alternate_email, unique: true
  end
end
