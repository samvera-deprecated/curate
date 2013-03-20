class ErrorsController < ApplicationController
  layout 'curate_nd'

  def show
    render_response_for_error(exception_wrapper)
  end

  def exception
    @exception ||= env['action_dispatch.exception']
  end
  protected :exception

  def exception_wrapper
    @exception_wrapper ||= ActionDispatch::ExceptionWrapper.new(env, exception)
  end
  helper_method :exception_wrapper
  protected :exception_wrapper

end
