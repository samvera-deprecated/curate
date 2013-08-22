class RegistrationsController < Devise::RegistrationsController
  include Curate::ThemedLayoutController
  with_themed_layout '1_column'

  protected
    def after_update_path_for(resource)
      resource.update_column(:user_does_not_require_profile_update, true)
      super
    end
end
