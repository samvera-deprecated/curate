class AddJavascriptEnabledToHelpRequest < ActiveRecord::Migration
  def change
    add_column :help_requests, :javascript_enabled, :boolean
  end
end
