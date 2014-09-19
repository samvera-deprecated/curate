class CurationConcern::ArticlesController < CurationConcern::GenericWorksController
  self.curation_concern_type = Article

  def setup_form
    curation_concern.creator << current_user.name if curation_concern.creator.empty? && !current_user.can_make_deposits_for.any?
    curation_concern.editors << current_user.person unless curation_concern.editors.present?
    curation_concern.editors.build
    curation_concern.editor_groups.build
  end
  protected :setup_form

end
