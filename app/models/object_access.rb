class ObjectAccess < ActiveRecord::Base
	self.establish_connection("#{Rails.env}_remote".to_sym)
	set_table_name "object_access"

	def create_object_access(purl)
		date_accessed= purl.date_created
		repo_object_id= purl.repo_object_id
		purl_id= purl.purl_id
		save
	end
end

