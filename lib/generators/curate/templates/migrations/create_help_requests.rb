class CreateHelpRequests < ActiveRecord::Migration
  def change
    create_table :help_requests do |t|
      t.string :view_port
      t.text :current_url
      t.string :user_agent
      t.string :resolution
      t.text :how_can_we_help_you
      t.integer :user_id
      t.boolean :javascript_enabled
      t.string :release_version

      t.timestamps
    end
    add_index :help_requests, :user_id
    add_index :help_requests, :created_at
  end

  def self.down
    drop_table :help_requests
  end
end
