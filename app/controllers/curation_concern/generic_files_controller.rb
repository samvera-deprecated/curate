class CurationConcern::GenericFilesController < CurationConcern::BaseController
  respond_to(:html)
  def curation_concern
    @curation_concern ||= GenericFile.find(params[:id])
  end

  def show
    respond_with(curation_concern)
  end

  def edit
    @curation_concern = GenericFile.find(params[:id])
    @terms = @curation_concern.terms_for_editing
    respond_with(@curation_concern, @terms)
  end

  def update
    @curation_concern = GenericFile.find(params[:id])
    CurationConcern::Actions.update_metadata(@curation_concern, current_user, params[:generic_file])
    CurationConcern::Actions.update_file(@curation_concern, current_user, params[:generic_file])
    CurationConcern::Actions.update_version(@curation_concern, current_user, params[:generic_file])
    respond_with([:curation_concern, @curation_concern])
  rescue ActiveFedora::RecordInvalid
    respond_with([:curation_concern, @curation_concern]) do |wants|
      wants.html { render 'edit', status: :unprocessable_entity }
    end
  end
end