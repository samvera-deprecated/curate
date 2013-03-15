class AddSiteVersionToHelpRequest < ActiveRecord::Migration
  def change
    add_column :help_requests, :release_version, :string
  end
end
