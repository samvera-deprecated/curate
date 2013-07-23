class RegistrationsController < Devise::RegistrationsController

  protected
    def after_update_path_for(resource)
      resource.update_column(:user_does_not_require_profile_update, true)
      super
    end
end
