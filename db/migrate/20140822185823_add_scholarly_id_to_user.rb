class AddScholarlyIdToUser < ActiveRecord::Migration
  def change
    add_column User.table_name, :researcher_id, :string, :length => 20
    add_column User.table_name, :scopus_id, :string, :length => 20
    add_column User.table_name, :orcid_id, :string, :length => 20
  end
end
