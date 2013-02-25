class ClassifyController < ApplicationController
  before_filter :authenticate_user!
  layout 'curate_nd/2_column'

  respond_to :html
  def index
    respond_with
  end

  protected
  def authenticate_user!
    super && agreed_to_terms_of_service
  end

  def agreed_to_terms_of_service
    return false unless current_user
    if current_user.agreed_to_terms_of_service?
      return current_user
    else
      redirect_to new_terms_of_service_agreement_path
      return false
    end
  end

end
