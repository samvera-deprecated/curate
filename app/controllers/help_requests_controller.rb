class HelpRequestsController < ApplicationController
  SUCCESS_NOTICE = "Thank you for your input!"
  layout 'curate_nd'
  before_filter :authenticate_user!
  before_filter :agreed_to_terms_of_service!

  respond_to(:html)
  def help_request
    @help_request ||= build_help_request
  end
  helper_method :help_request

  def new
    respond_with(help_request)
  end

  def create
    help_request.save!
    respond_with(help_request) do |wants|
      wants.html { redirect_to dashboard_index_path, notice: SUCCESS_NOTICE}
    end
  rescue ActiveRecord::RecordInvalid
    respond_with(help_request)
  end

  private

  def build_help_request
    help_request = HelpRequest.new(params[:help_request])
    help_request.user_agent  ||= user_agent_from_request
    help_request
  end

  def user_agent_from_request
    request.headers['HTTP_USER_AGENT']
  end
end
