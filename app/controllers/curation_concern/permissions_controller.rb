class CurationConcern::PermissionsController < CurationConcern::BaseController
  with_themed_layout '1_column'

  def confirm
  end

  def copy
    Sufia.queue.push(VisibilityCopyWorker.new(curation_concern.id))
    flash_message = 'Updating file permissions. This may take a few minutes. You may want to refresh your browser or return to this record later to see the updated file permissions.'
    redirect_to polymorphic_path([:curation_concern, curation_concern]), notice: flash_message
  end

  self.curation_concern_type = ActiveFedora::Base
end
