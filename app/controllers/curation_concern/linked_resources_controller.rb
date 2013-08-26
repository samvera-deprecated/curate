class CurationConcern::LinkedResourcesController < CurationConcern::BaseController

  respond_to(:html)

  include Curate::ParentContainer
  before_filter :parent
  before_filter :authorize_edit_parent_rights!, except: [:show]

  self.excluded_actions_for_curation_concern_authorization = [:new, :create]


  def new
    respond_with(curation_concern)
  end

  def create
    curation_concern.batch = parent
    actor.create!
    respond_with([:curation_concern, parent])
  rescue ActiveFedora::RecordInvalid
    respond_with([:curation_concern, curation_concern]) { |wants|
      wants.html { render 'new', status: :unprocessable_entity }
    }
  end


  def curation_concern
    @curation_concern ||=
    if params[:id]
      LinkedResource.find(params[:id])
    else
      LinkedResource.new(params[:linked_resource])
    end
  end
  protected :curation_concern

  def attach_action_breadcrumb
    add_breadcrumb "#{parent.human_readable_type}", polymorphic_path([:curation_concern, parent])
    super
  end

  include Morphine
  register :actor do
    CurationConcern.actor(curation_concern, current_user, params[:linked_resource])
  end

end
