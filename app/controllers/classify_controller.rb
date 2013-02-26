class ClassifyController < ApplicationController
  before_filter :authenticate_user!
  before_filter :agreed_to_terms_of_service!
  layout 'curate_nd/2_column'

  respond_to :html
  def index
    respond_with
  end
end
