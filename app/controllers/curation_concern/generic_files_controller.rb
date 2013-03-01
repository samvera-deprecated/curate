class CurationConcern::GenericFilesController < CurationConcern::BaseController
  respond_to(:html)

  before_filter :parent_curation_concern
  load_and_authorize_resource :parent_curation_concern, class: "ActiveFedora::Base"

  def parent_curation_concern
    @parent_curation_concern ||=
    if params[:id]
      GenericFile.find(params[:id]).batch
    else
      ActiveFedora::Base.find(
        namespaced_parent_curation_concern_id,
        cast: true
      )
    end
  end
  helper_method :parent_curation_concern

  def namespaced_parent_curation_concern_id
    Sufia::Noid.namespaceize(params[:parent_curation_concern_id])
  end
  protected :namespaced_parent_curation_concern_id

  def curation_concern
    @curation_concern ||=
    if params[:id]
      GenericFile.find(params[:id])
    else
      GenericFile.new(params[:generic_file])
    end
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
    respond_with([:curation_concern, curation_concern]) do |wants|
      wants.html { render 'edit', status: :unprocessable_entity }
    end
  end

  include Morphine
  register :actor do
    CurationConcern::GenericFileActor.new(
      curation_concern,
      current_user,
      params[:generic_file]
    )
  end
end
