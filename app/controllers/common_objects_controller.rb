class CommonObjectsController < ApplicationController
  respond_to(:html)
  include Sufia::Noid # for normalize_identifier method

  def curation_concern
    @curation_concern ||= ActiveFedora::Base.find(params[:id], cast: true)
  end
  before_filter :curation_concern
  helper_method :curation_concern
  prepend_before_filter :normalize_identifier
  load_and_authorize_resource :curation_concern, class: "ActiveFedora::Base"
  layout 'common_objects'

  helper :common_objects

  def show
    respond_with(curation_concern)
  end

end
