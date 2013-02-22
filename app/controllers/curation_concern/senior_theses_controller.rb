class CurationConcern::SeniorThesesController < CurationConcern::BaseController
  respond_to(:html)

  def new
    @curation_concern = SeniorThesis.new(params[:senior_thesis])
  end

  def create
    @curation_concern = SeniorThesis.new(pid: CurationConcern.mint_a_pid)
    CurationConcern::Actions.create_metadata(@curation_concern, current_user, params[:senior_thesis])
    respond_with([:curation_concern,@curation_concern])
  rescue ActiveFedora::RecordInvalid
    respond_with([:curation_concern, @curation_concern]) do |wants|
      wants.html { render 'new', status: :unprocessable_entity }
    end
  end

  def show
    @curation_concern = SeniorThesis.find(params[:id])
    respond_with(@curation_concern)
  end

  def edit
    @curation_concern = SeniorThesis.find(params[:id])
    respond_with(@curation_concern)
  end

  def update
    @curation_concern = SeniorThesis.find(params[:id])
    CurationConcern::Actions.update_metadata(@curation_concern, current_user, params[:senior_thesis])
    respond_with([:curation_concern, @curation_concern])
  rescue ActiveFedora::RecordInvalid
    respond_with([:curation_concern, @curation_concern]) do |wants|
      wants.html { render 'edit', status: :unprocessable_entity }
    end
  end

  def destroy
  end

end
