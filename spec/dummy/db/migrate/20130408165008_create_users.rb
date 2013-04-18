class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.boolean :agreed_to_terms_of_service
      t.string :encrypted_password
      t.integer :sign_in_count, default: 0
      t.timestamps
    end
    add_index :users, :email
  end
end
