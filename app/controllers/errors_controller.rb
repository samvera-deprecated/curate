class ErrorsController < ApplicationController
  layout 'curate_nd'

  def show
    set_return_location_if_applicable
    respond_to do |format|
      format.html { render :show, status: status_code, layout: !request.xhr? }
      format.xml  { render xml: details, root: "error", status: status_code }
      format.json { render json: {error: details}, status: status_code }
    end
  end

  def set_return_location_if_applicable
    if rescue_response == :unauthorized
      session['user_return_to'] = env['ORIGINAL_FULLPATH']
    end
  end
  protected :set_return_location_if_applicable


  def exception
    @exception ||= env['action_dispatch.exception']
  end
  helper_method :exception
  protected :exception

  def status_code
    @status_code ||= ActionDispatch::ExceptionWrapper.new(env, exception).status_code
  end
  helper_method :status_code
  protected :status_code

  def details
    @details ||= {}.tap do |h|
      I18n.with_options({
        scope: [:exception, :show, rescue_response],
        exception_name: exception.class.name,
        exception_message: exception.message
      }) do |i18n|
        h[:title]    = i18n.t "#{exception.class.name.underscore}.title", default: i18n.t(:title, default: exception.class.name)
        h[:response_type] = rescue_response
        h[:message] = i18n.t "#{exception.class.name.underscore}.description", default: i18n.t(:description, default: exception.message)
      end
    end
  end
  helper_method :details
  protected :details

  def rescue_response
    @rescue_response ||= ActionDispatch::ExceptionWrapper.rescue_responses[exception.class.name]
  end
  helper_method :rescue_response
  protected :rescue_response

end
