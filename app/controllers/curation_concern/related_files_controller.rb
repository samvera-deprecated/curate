class CurationConcern::RelatedFilesController < CurationConcern::BaseController
  respond_to(:html)
  before_filter :parent_curation_concern
  load_and_authorize_resource :parent_curation_concern, class: "ActiveFedora::Base"

  def curation_concern
    @curation_concern ||=
    if params[:id]
      GenericFile.find(params[:id])
    else
      GenericFile.new(params[:generic_file])
    end
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
  end
end
