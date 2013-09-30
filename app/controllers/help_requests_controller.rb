class HelpRequestsController < ApplicationController
  SUCCESS_NOTICE = "Thank you for your input!"
  with_themed_layout
  before_filter :authenticate_user!
  before_filter :agreed_to_terms_of_service!

  add_breadcrumb 'Help Request', lambda {|controller| controller.request.path }

  respond_to(:html)
  def help_request
    @help_request ||= build_help_request
  end
  helper_method :help_request

  def new
    respond_with(help_request)
  end

  def create
    if help_request.save
      respond_with(help_request) do |wants|
        wants.html { redirect_to catalog_index_path, notice: SUCCESS_NOTICE}
      end
    else
      respond_with(help_request)
    end
  end

  private

  def build_help_request
    help_request = HelpRequest.new()
    unless params[:action] == 'new'
      help_request.attributes = params.require(:help_request).permit(
        :current_url,
        :flash_version,
        :how_can_we_help_you,
        :javascript_enabled,
        :resolution,
        :user_agent,
        :view_port
      )
    end

    help_request.user_agent  ||= user_agent_from_request
    help_request.release_version = Curate.configuration.build_identifier
    help_request.user = current_user
    help_request
  end

  def user_agent_from_request
    request.headers['HTTP_USER_AGENT']
  end
end
