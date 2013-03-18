class Purl < ActiveRecord::Base
  self.establish_connection("#{Rails.env}_remote_purl_database".to_sym)
  self.table_name = "purl"

  attr_accessible :date_created

  def self.create_from_repo_object(repo_object)
    if repo_object.nil?
      return
    end
    create do |purl|
      purl.repo_object_id= repo_object.repo_object_id
      purl.access_count= 0
      purl.date_created= repo_object.date_added
    end
  end

end
