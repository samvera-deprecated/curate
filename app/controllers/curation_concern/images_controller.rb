class CurationConcern::ImagesController < CurationConcern::GenericWorksController
  self.curation_concern_type = Image

  def setup_form
    super
    curation_concern.creator << current_user.name if curation_concern.creator.empty?
  end
end
