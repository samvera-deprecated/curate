class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  # Adds Hydra behaviors into the application controller
  include Hydra::Controller::ControllerBehavior
  # Adds Sufia behaviors into the application controller
  include Sufia::Controller

  # Please be sure to impelement current_user and user_session. Blacklight depends on
  # these methods in order to perform user specific actions.

  layout 'hydra-head'

  protect_from_forgery

  def show_action_bar?
    true
  end
  helper_method :show_action_bar?

  def show_site_search?
    true
  end
  helper_method :show_site_search?

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
