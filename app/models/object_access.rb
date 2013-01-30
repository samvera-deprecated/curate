class ObjectAccess < ActiveRecord::Base
	self.establish_connection("#{Rails.env}_remote_purl_database".to_sym)
	self.table_name = "object_access"

	attr_accessible :access_id, :purl_id, :repo_object_id, :ip_address, :date_accessed, :host_name, :request_method, :path_info

	def self.create_from_purl(purl)
		if purl.nil?
			return
		end
		create do |object_access|
			object_access.date_accessed= purl.date_created
			object_access.repo_object_id= purl.repo_object_id
			object_access.purl_id= purl.purl_id
		end
	end
end

