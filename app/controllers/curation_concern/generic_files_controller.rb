class CurationConcern::GenericFilesController < CurationConcern::BaseController
  respond_to(:html)
  def curation_concern
    @curation_concern ||= GenericFile.find(params[:id])
  end

  def show
    respond_with(curation_concern)
  end

  def edit
    respond_with(curation_concern)
  end

  def update
    actor = CurationConcern::GenericFileActor.new(curation_concern, current_user, params[:generic_file])
    actor.update

    respond_with([:curation_concern, curation_concern])
  rescue ActiveFedora::RecordInvalid
    respond_with([:curation_concern, curation_concern]) do |wants|
      wants.html { render 'edit', status: :unprocessable_entity }
    end
  end
end