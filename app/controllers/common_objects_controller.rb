require File.expand_path('../../helpers/common_objects_helper', __FILE__)
class CommonObjectsController < ApplicationController
  include Hydra::Controller::ControllerBehavior
  layout 'common_objects'

  respond_to(:html)
  include Sufia::Noid # for normalize_identifier method
  prepend_before_filter :normalize_identifier
  def curation_concern
    @curation_concern ||= ActiveFedora::Base.find(params[:id], cast: true)
  end
  before_filter :curation_concern
  helper_method :curation_concern
  helper CommonObjectsHelper

  before_filter :enforce_show_permissions, only: [:show]
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
