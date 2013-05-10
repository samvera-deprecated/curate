class CurationConcern::GenericFilesController < CurationConcern::BaseController
  respond_to(:html)

  def attach_action_breadcrumb
    add_breadcrumb "#{parent.human_readable_type}", polymorphic_path([:curation_concern, parent])
    super
  end

  before_filter :parent
  def parent
    @parent ||=
    if params[:id]
      curation_concern.batch
    else
      ActiveFedora::Base.find(namespaced_parent_id,cast: true)
    end
  end
  helper_method :parent

  def namespaced_parent_id
    Sufia::Noid.namespaceize(params[:parent_id])
  end
  protected :namespaced_parent_id

  before_filter :authorize_edit_parent_rights!, except: [:show]
  def authorize_edit_parent_rights!
    authorize! :edit, parent
  end
  protected :authorize_edit_parent_rights!

  self.excluded_actions_for_curation_concern_authorization = [:new, :create]
  def action_name_for_authorization
    (action_name == 'versions' || action_name == 'rollback') ? :edit : super
  end
  protected :action_name_for_authorization

  def curation_concern
    @curation_concern ||=
    if params[:id]
      GenericFile.find(params[:id])
    else
      GenericFile.new(params[:generic_file])
    end
  end

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


  def show
    respond_with(curation_concern)
  end

  def edit
    respond_with(curation_concern)
  end

  def update
    actor.update!
    respond_with([:curation_concern, curation_concern])
  rescue ActiveFedora::RecordInvalid
    respond_with([:curation_concern, curation_concern]) { |wants|
      wants.html { render 'edit', status: :unprocessable_entity }
    }
  end

  def versions
    respond_with(curation_concern)
  end

  def rollback
    retrieve_version
    respond_with([:curation_concern, curation_concern])
  end

  def destroy
    parent = curation_concern.batch
    title = curation_concern.to_s
    curation_concern.destroy
    flash[:notice] = "Deleted #{title}"
    respond_with([:curation_concern, parent])
  end

  include Morphine
  register :actor do
    CurationConcern.actor(curation_concern, current_user, params[:generic_file])
  end

  private

  def retrieve_version
    revision = curation_concern.content.get_version(params["generic_file"]["version"])
    curation_concern.add_file_datastream(revision.content, :label => revision.label, :dsid => 'content')
    curation_concern.record_version_committer(current_user)
    curation_concern.save!
  end
end
