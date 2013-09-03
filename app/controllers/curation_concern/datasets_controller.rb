class CurationConcern::DatasetsController < CurationConcern::GenericWorksController

  register :actor do
    CurationConcern.actor(curation_concern, current_user, params[:dataset])
  end
  register :curation_concern do
    if params[:id]
      Dataset.find(params[:id])
    else
      Dataset.new(params[:dataset])
    end
  end
end
