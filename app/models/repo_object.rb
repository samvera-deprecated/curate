class RepoObject < ActiveRecord::Base
  self.establish_connection("#{Rails.env}_remote_purl_database".to_sym)
  self.table_name = "repo_object"
  attr_accessible :pid, :repo_object_id, :url, :date_added, :date_modified, :add_source_ip, :information
  alias_attribute :pid, :filename

  def self.create_repo_object(fedora_object)
    if fedora_object.nil?
      return
    end
    create do |repo_object|
      repo_object.url= fedora_object.url
      repo_object.pid= fedora_object.pid
      repo_object.date_added= fedora_object.create_date
      repo_object.date_modified= fedora_object.modified_date
      repo_object.information= fedora_object.information
    end
  end

end
