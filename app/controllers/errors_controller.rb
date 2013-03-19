class ErrorsController < ApplicationController
  def not_found
    render 'not_found', status: :not_found, layout: 'curate_nd'
  end

  def unauthorized
    render("unauthorized", status: :unauthorized, layout: 'curate_nd')
  end
end