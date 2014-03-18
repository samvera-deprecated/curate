class RegistrationsController < Devise::RegistrationsController
  include Curate::ThemedLayoutController
  with_themed_layout '1_column'

  def update
    if current_user.manager?
      self.resource = resource_class.to_adapter.get!(User.find(params[:user][:id]))
    else
      self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    end
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if current_user.manager?
      if account_update_params[:password].blank?
        account_update_params.delete("password")
        account_update_params.delete("password_confirmation")
      end
      successfully_updated = resource.update_without_password(account_update_params)
    else
      successfully_updated = update_resource(resource, account_update_params)
    end

    if successfully_updated
      yield resource if block_given?
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true unless current_user.manager?
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  protected

  def after_update_path_for(resource)
    resource.update_column(:user_does_not_require_profile_update, true)
    super
  end

  def resource_class
    Account
  end

  def sign_up(resource_name, resource)
    sign_in(resource_name, resource.user)
  end

end
