class CommonObjectsController < ApplicationController
  respond_to(:html)
  include Sufia::Noid # for normalize_identifier method

  def curation_concern
    @curation_concern ||= ActiveFedora::Base.find(params[:id], cast: true)
  end
  before_filter :curation_concern
  before_filter :enforce_show_permissions, only: [:show]
  helper_method :curation_concern
  prepend_before_filter :normalize_identifier
  layout 'common_objects'

  helper :common_objects

  rescue_from Hydra::AccessDenied do |exception|
    redirect_to common_object_stub_information_path(curation_concern)
  end

  def show
    respond_with(curation_concern)
  end

  def show_stub_information
    respond_with(curation_concern)
  end
end
