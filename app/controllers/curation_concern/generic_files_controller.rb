class CurationConcern::GenericFilesController < CurationConcern::BaseController
  respond_to(:html)

  def show
    @curation_concern = GenericFile.find(params[:id])
    respond_with(@curation_concern)
  end

  def edit
    @curation_concern = GenericFile.find(params[:id])
    respond_with(@curation_concern)
  end
end