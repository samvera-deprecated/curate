class Purl < ActiveRecord::Base
	self.establish_connection("#{Rails.env}_remote".to_sym)
	set_table_name "purl"

	def create_purl(repo_object)
		repo_object_id= repo_object.repo_object_id
		access_count= 0
		date_created= repo_object.date_added
		save
	end
end

