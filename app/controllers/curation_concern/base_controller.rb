class CurationConcern::BaseController < ApplicationController
  layout 'curate_nd'
  include Sufia::Noid # for normalize_identifier method

  before_filter :authenticate_user!, :except => [:show, :citation]
  before_filter :agreed_to_terms_of_service!
  before_filter :has_access?, :except => [:show]
  prepend_before_filter :normalize_identifier, except: [:index, :new, :create]
  before_filter :curation_concern, except: [:index]
  load_and_authorize_resource :curation_concern, except: [:index, :new, :create]

  # Catch permission errors
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

  attr_reader :curation_concern
  helper_method :curation_concern

  def contributor_agreement
    @contributor_agreement ||= ContributorAgreement.new(curation_concern, current_user, params)
  end
  helper_method :contributor_agreement

end
