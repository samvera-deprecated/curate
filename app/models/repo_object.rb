require 'method_decorators/precondition'

class RepoObject < ActiveRecord::Base
  extend MethodDecorators
  self.establish_connection("#{Rails.env}_remote_purl_database".to_sym)
  self.table_name = "repo_object"
  # this is the id for the record, NOT for the repository object (which is :pid)
  attr_accessible :add_source_ip
  alias_attribute :pid, :filename

  class << self
    +MethodDecorators::Precondition.new {|fedora_object| fedora_object.present? }
    def create_from_fedora_object(fedora_object)
      create do |repo_object|
        repo_object.url = File.join(Rails.configuration.application_url, "show", fedora_object.to_param)
        repo_object.pid = fedora_object.to_param
        repo_object.date_added= fedora_object.create_date
        repo_object.date_modified= fedora_object.modified_date
        repo_object.information= "CurateND - #{fedora_object.to_param}"
      end
    end
  end

end
