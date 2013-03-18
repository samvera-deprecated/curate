class RepoObject < ActiveRecord::Base
  self.establish_connection("#{Rails.env}_remote_purl_database".to_sym)
  self.table_name = "repo_object"
  # this is the id for the record, NOT for the repository object (which is :pid)
  attr_accessible :add_source_ip
  alias_attribute :pid, :filename

  def self.create_from_fedora_object(fedora_object)
    if fedora_object.nil?
      return
    end
    create do |repo_object|
      repo_object.url = File.join(Rails.configuration.application_url,"show", fedora_object.pid)
      repo_object.pid = fedora_object.pid
      repo_object.date_added= fedora_object.create_date
      repo_object.date_modified= fedora_object.modified_date
      repo_object.information= "CurateND - #{fedora_object.pid}"
    end
  end

end
