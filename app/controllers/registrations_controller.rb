class RegistrationsController < Devise::RegistrationsController

  protected
    def after_update_path_for(resource)
      resource.update_column(:force_update_profile, false)
      super
    end
end
