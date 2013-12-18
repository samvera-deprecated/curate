class Authentication < ActiveRecord::Base
  belongs_to :user

  def self.find_by_provider_and_uid(provider, uid)
    authentication = Authentication.where(provider: provider, uid: uid)
    return authentication.first unless authentication.empty?
  end
end
