class CurationConcern::SeniorThesesController < CurationConcern::BaseController
  respond_to(:html)
  def curation_concern
    @curation_concern ||=
    if params[:id]
      SeniorThesis.find(params[:id])
    else
      SeniorThesis.new(params[:senior_thesis])
    end
  end
  def new
  end

  def create
    if verify_acceptance_of_user_agreement!
      begin
        @curation_concern = SeniorThesis.new(pid: CurationConcern.mint_a_pid)
        actor = CurationConcern::SeniorThesisActor.new(
          curation_concern, current_user, params[:senior_thesis]
        )
        actor.create
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
    respond_with(curation_concern)
  end

  def edit
    respond_with(curation_concern)
  end

  def update
    actor.update
    respond_with([:curation_concern, curation_concern])
  rescue ActiveFedora::RecordInvalid
    respond_with([:curation_concern, curation_concern]) do |wants|
      wants.html { render 'edit', status: :unprocessable_entity }
    end
  end

  def destroy
  end

  def actor
    @actor ||= CurationConcern::SeniorThesisActor.new(
      curation_concern,
      current_user,
      params[:senior_thesis]
    )
  end
end
