class ClassifyController < ApplicationController
  before_filter :authenticate_user!
  layout 'curate_nd/2_column'

  respond_to :html
  def index
    respond_with
  end
end
