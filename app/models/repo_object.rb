class RepoObject < ActiveRecord::Base
	self.establish_connection("#{Rails.env}_remote".to_sym)
	set_table_name "repo_object"
	
	def create_repo_object(fedora_object)
		url= fedora_object.url
		filename= fedora_object.filename
		date_added= fedora_object.date_created
		date_modified= fedora_object.date_modified
		information= fedora_object.info
		save
	end
end

