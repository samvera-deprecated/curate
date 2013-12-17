class SessionsController < Devise::SessionsController
  include Curate::ThemedLayoutController
  with_themed_layout '1_column'

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?
    if session[:omniauth]
      sync_authentication_from_external_site(resource)
    end
    respond_with resource, :location => after_sign_in_path_for(resource)
  end

  private

  def sync_authentication_from_external_site(resource)
    resource.apply_omniauth(session[:omniauth])
    resource.save
  end
end
