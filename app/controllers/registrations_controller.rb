class RegistrationsController < Devise::RegistrationsController
  include Curate::ThemedLayoutController
  with_themed_layout '1_column'

  # @TODO - Instead of updating user accounts via the registration controller,
  #         expose a resource for updating an account. It is possible that the
  #         resource would only be available for repository managers.
  def update(&block)
    if current_user.manager?
      manager_is_updating_a_user_registration(&block)
    else
      current_user_is_updating_their_user_registration(&block)
    end
  end

  protected

  def manager_is_updating_a_user_registration(&block)
    manager_is_editing_another_user = params.fetch(:user, {}).fetch(:id, nil)
    if manager_is_editing_another_user
      user = User.find(params[:user][:id])
      self.resource = resource_class.to_adapter.get!(user)
      scrub_password_parameters_for_manager!
      update_status = resource.update_without_password(account_update_params)
      handle_update_response(update_status: update_status, skip_signin: true, &block)
    else
      curruent_user_is_updating_their_user_registration(&block)
    end
  end

  def current_user_is_updating_their_user_registration(&block)
    user = send(:"current_#{resource_name}").to_key
    self.resource = resource_class.to_adapter.get!(user)
    update_status = resource.update_with_password(account_update_params)
    handle_update_response(successful_update: update_status, skip_signin: false, &block)
  end

  def handle_update_response(options = {}, &block)
    skip_signin = options.fetch(:skip_signin) { false }
    successful_update = options.fetch(:successful_update)
    if successful_update
      yield(resource) if block_given?
      if is_navigational_format?
        flash_key =
        if update_needs_confirmation?(resource, prev_unconfirmed_email)
          :update_needs_confirmation
        else
          :updated
        end
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true unless skip_signin
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def after_update_path_for(resource)
    resource.update_column(:user_does_not_require_profile_update, true)
    super
  end

  def scrub_password_parameters_for_manager!
    if account_update_params[:password].blank?
      account_update_params.delete('password')
      account_update_params.delete('password_confirmation')
    end
  end

  def prev_unconfirmed_email
    if resource.respond_to?(:unconfirmed_email)
      resource.unconfirmed_email
    else
      nil
    end
  end

  def resource_class
    Account
  end

  def sign_up(resource_name, resource)
    sign_in(resource_name, resource.user)
  end

end
