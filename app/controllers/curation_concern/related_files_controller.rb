class CurationConcern::RelatedFilesController < CurationConcern::BaseController
  respond_to(:html)
  before_filter :parent_curation_concern
  load_and_authorize_resource :parent_curation_concern, class: "ActiveFedora::Base"

  def curation_concern
    @curation_concern ||= RelatedFile.new(params[:related_file])
  end

  def parent_curation_concern
    @parent_curation_concern ||= ActiveFedora::Base.find(
      namespaced_parent_curation_concern_id,
      cast: true
    )
  end
  helper_method :parent_curation_concern

  def namespaced_parent_curation_concern_id
    Sufia::Noid.namespaceize(params[:parent_curation_concern_id])
  end
  protected :namespaced_parent_curation_concern_id

  def new
    respond_with(curation_concern)
  end

  def create
    actor.create!
    respond_with([:curation_concern, parent_curation_concern])
  rescue ActiveFedora::RecordInvalid
    respond_with([:curation_concern, curation_concern]) do |wants|
      wants.html { render 'new', status: :unprocessable_entity }
    end
  end

  include Morphine
  register :actor do
  end

end
