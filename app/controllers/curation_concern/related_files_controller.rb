class CurationConcern::RelatedFilesController < ApplicationController
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
end
