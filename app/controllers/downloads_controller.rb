require 'sufia/models/noid'

class DownloadsController < ApplicationController
  include Sufia::Noid # for normalize_identifier method
  include Hydra::Controller::DownloadBehavior
  prepend_before_filter :normalize_identifier, except: [:index, :new, :create]

  protected

  def render_404
    if params.has_key?(:datastream_id) and params[:datastream_id] == "thumbnail"
      send_default_image
    else
      super
    end
  end

  # Send default thumbnail image
  def send_default_image
    image= ActionController::Base.helpers.asset_path("curate/default.png", type: :image)
    redirect_to image
  end

end
