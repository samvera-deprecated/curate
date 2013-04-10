class ClassifyConcernsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :agreed_to_terms_of_service!
  layout 'curate_nd/2_column'
  respond_to :html

  def classify_concern
    @classify_concern ||= ClassifyConcern.new(params[:classify_concern])
  end
  helper_method :classify_concern

  def new
    respond_with(classify_concern)
  end

  def create
    if classify_concern.valid?
      respond_with(classify_concern) do |wants|
        wants.html do
          redirect_to new_polymorphic_path(
            [:curation_concern, classify_concern.curation_concern_class]
          )
        end
      end
    else
      respond_with(classify_concern)
    end
  end
end
