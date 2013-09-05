class CurationConcern::ArticlesController < CurationConcern::GenericWorksController

  register :actor do
    CurationConcern.actor(curation_concern, current_user, params[:article])
  end
  register :curation_concern do
    if params[:id]
      Article.find(params[:id])
    else
      Article.new(params[:article])
    end
  end
end
