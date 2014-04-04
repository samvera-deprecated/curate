class CurationConcern::GenericFilesController < CurationConcern::BaseController
  include Curate::ParentContainer

  respond_to(:html)

  def attach_action_breadcrumb
    add_breadcrumb "#{parent.human_readable_type}", polymorphic_path([:curation_concern, parent])
    super
  end

  before_filter :parent
  before_filter :cloud_resources_valid?, only: :create
  before_filter :authorize_edit_parent_rights!, except: [:show]

  self.excluded_actions_for_curation_concern_authorization = [:new, :create]
  def action_name_for_authorization
    (action_name == 'versions' || action_name == 'rollback') ? :edit : super
  end
  protected :action_name_for_authorization

  def cloud_resources_valid?
    if params.has_key?(:selected_files) && params[:selected_files].length>1
      respond_with([:curation_concern, curation_concern]) do |wants|
        wants.html {
          flash.now[:error] = "Please select one cloud resource at a time."
          render 'new', status: :unprocessable_entity
        }
      end
      return false
    end
  end

  protected :cloud_resources_valid?

  self.curation_concern_type = GenericFile

  def new
    curation_concern.copy_permissions_from(parent)
    respond_with(curation_concern)
  end

  def create
    curation_concern.batch = parent
    if actor.create
      curation_concern.update_parent_representative_if_empty(parent)
      respond_with([:curation_concern, parent])
    else
      respond_with([:curation_concern, curation_concern]) { |wants|
        wants.html { render 'new', status: :unprocessable_entity }
      }
    end
  end


  def show
    respond_with(curation_concern)
  end

  def edit
    respond_with(curation_concern)
  end

  def update
    if actor.update
      respond_with([:curation_concern, parent])
    else
      respond_with([:curation_concern, curation_concern]) { |wants|
        wants.html { render 'edit', status: :unprocessable_entity }
      }
    end
  end

  def versions
    respond_with(curation_concern)
  end

  def rollback
    if actor.rollback
      respond_with([:curation_concern, curation_concern])
    else
      respond_with([:curation_concern, curation_concern]) { |wants|
        wants.html { render 'versions', status: :unprocessable_entity }
      }
    end
  end

  def destroy
    parent = curation_concern.batch
    flash[:notice] = "Deleted #{curation_concern}"
    curation_concern.destroy
    respond_with([:curation_concern, parent])
  end

  register :actor do
    CurationConcern.actor(curation_concern, current_user, attributes_for_actor)
  end
end
