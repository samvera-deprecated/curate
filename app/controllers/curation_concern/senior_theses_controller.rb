class CurationConcern::SeniorThesesController < CurationConcern::BaseController
  respond_to(:html)

  def new
    @curation_concern = SeniorThesis.new(params[:senior_thesis])
  end

  def create
    if verify_acceptance_of_user_agreement!
      begin
        @curation_concern = SeniorThesis.new(pid: CurationConcern.mint_a_pid)
        CurationConcern::Actions.create_metadata(@curation_concern, current_user, params[:senior_thesis])
        respond_with([:curation_concern, @curation_concern])
      rescue ActiveFedora::RecordInvalid
        respond_with([:curation_concern, @curation_concern]) do |wants|
          wants.html { render 'new', status: :unprocessable_entity }
        end
      end
    end
  end

  def verify_acceptance_of_user_agreement!
    if contributor_agreement.is_being_accepted?
      return true
    else
      # Calling the new action to make sure we are doing our best to preserve
      # the input values; Its a stretch but hopefully it'll work
      self.new
      respond_with([:curation_concern, curation_concern]) do |wants|
        wants.html {
          flash.now[:error] = "You must accept the contributor agreement"
          render 'new', status: :conflict
        }
      end
      return false
    end
  end
  protected :verify_acceptance_of_user_agreement!

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
