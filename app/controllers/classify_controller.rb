class ClassifyController < ApplicationController
  before_filter :authenticate_user!
  before_filter :agreed_to_terms_of_service!
  layout 'curate_nd/2_column'
  respond_to :html

  def new
    respond_with
  end

  def create
  end
end
