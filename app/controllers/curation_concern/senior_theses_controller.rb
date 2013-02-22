class CurationConcern::SeniorThesesController < CurationConcern::BaseController
  respond_to(:html)

  attr_reader :senior_thesis
  helper_method :senior_thesis

  def new
    @senior_thesis = SeniorThesis.new(params[:senior_thesis])
  end

  def create
    @senior_thesis = SeniorThesis.new(pid: CurationConcern.mint_a_pid)
    CurationConcern::Actions.create_metadata(@senior_thesis, current_user, params[:senior_thesis])
    respond_with([:curation_concern,@senior_thesis])
  rescue ActiveFedora::RecordInvalid
    respond_with([:curation_concern, @senior_thesis]) do |wants|
      wants.html { render 'new', status: :unprocessable_entity }
    end
  end

  def show
    @senior_thesis = SeniorThesis.find(params[:id])
    respond_with(@senior_thesis)
  end

  def edit
    @senior_thesis = SeniorThesis.find(params[:id])
    respond_with(@senior_thesis)
  end

  def update
    @senior_thesis = SeniorThesis.find(params[:id])
    CurationConcern::Actions.update_metadata(@senior_thesis, current_user, params[:senior_thesis])
    respond_with([:curation_concern, @senior_thesis])
  rescue ActiveFedora::RecordInvalid
    respond_with([:curation_concern, @senior_thesis]) do |wants|
      wants.html { render 'edit', status: :unprocessable_entity }
    end
  end

  def destroy
  end

end
