class CurationConcern::PermissionsController < CurationConcern::BaseController
  with_themed_layout '1_column'

  def confirm
  end

  def copy
    Sufia.queue.push(VisibilityCopyWorker.new(curation_concern.id))
    redirect_to polymorphic_path([:curation_concern, curation_concern]), notice: 'Updating file permissions. This may take a few minutes.'
  end

  def curation_concern
    @curation_concern ||=
    if params[:id]
      ActiveFedora::Base.find(params[:id], cast: true)
      #ActiveFedora::Base.load_instance_from_solr(params[:id])
    else
      raise "Missing required parameter `id'"
    end
  end

end
