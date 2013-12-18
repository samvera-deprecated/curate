class AuthenticationsController < ApplicationController

  # Create a method for each provider
  # Example: cas, twitter, facebook, etc.
  #
  #def cas
  #  authentication_from_external_app
  #end

  private

  def authentication_from_external_app
    omni = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omni['provider'], omni['uid'])
    if authentication
      flash[:noitce] = "Logged in Successfully"
      sign_in_and_redirect authentication.user
    else
      session[:omniauth] = omni.except('extra')
      redirect_to new_user_registration_path
    end
  end
end
