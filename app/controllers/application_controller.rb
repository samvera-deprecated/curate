class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  # Adds Hydra behaviors into the application controller
  include Hydra::Controller::ControllerBehavior
  # Adds Sufia behaviors into the application controller
  include Sufia::Controller

  # Catch permission errors
  rescue_from ActiveFedora::ObjectNotFoundError do |exception|
    render '/errors/not_found', status: :not_found
  end

  rescue_from Hydra::AccessDenied, CanCan::AccessDenied do |exception|
    if (exception.action == :edit)
      redirect_to(
        url_for(action: 'show'),
        alert: "You do not have sufficient privileges to edit this document"
      )
    elsif current_user and current_user.persisted?
      redirect_to root_url, alert: exception.message
    else
      session["user_return_to"] = request.url
      redirect_to new_user_session_url, alert: exception.message
    end
  end


  # Please be sure to impelement current_user and user_session. Blacklight depends on
  # these methods in order to perform user specific actions.

  layout 'hydra-head'

  protect_from_forgery

  protected
  def agreed_to_terms_of_service!
    return false unless current_user
    if current_user.agreed_to_terms_of_service?
      return current_user
    else
      redirect_to new_terms_of_service_agreement_path
      return false
    end
  end

end
