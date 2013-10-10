class CurationConcern::GenericWorksController < CurationConcern::BaseController
  respond_to(:html)
  with_themed_layout '1_column'

  def new
    setup_form
  end

  def create
    if verify_acceptance_of_user_agreement!
      self.curation_concern.inner_object.pid = CurationConcern.mint_a_pid
      if actor.create
        after_create_response
      else
        setup_form
        respond_with([:curation_concern, curation_concern]) do |wants|
          wants.html { render 'new', status: :unprocessable_entity }
        end
      end
    end
  end

  def after_create_response
    respond_with([:curation_concern, curation_concern])
  end
  protected :after_create_response

  # Override setup_form in concrete controllers to get the form ready for display
  def setup_form 
  end
  protected :setup_form

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
    setup_form
    respond_with(curation_concern)
  end

  def update
    if actor.update
      after_update_response
    else
      setup_form
      respond_with([:curation_concern, curation_concern]) do |wants|
        wants.html { render 'edit', status: :unprocessable_entity }
      end
    end
  end

  def after_update_response
    if actor.visibility_changed?
      redirect_to confirm_curation_concern_permission_path(curation_concern)
    else
      respond_with([:curation_concern, curation_concern])
    end
  end
  protected :after_update_response

  def destroy
    title = curation_concern.to_s
    curation_concern.destroy
    after_destroy_response
  end

  def after_destroy_response
    flash[:notice] = "Deleted #{title}"
    respond_with { |wants|
      wants.html { redirect_to catalog_index_path }
    }
  end
  protected :after_destroy_response

  class_attribute :curation_concern_type
  self.curation_concern_type = GenericWork

  include Morphine
  register :actor do
    CurationConcern.actor(curation_concern, current_user, params[hash_key_for_curation_concern])
  end
  register :curation_concern do
    if params[:id]
      curation_concern_type.find(params[:id])
    else
      curation_concern_type.new
    end
  end

  def hash_key_for_curation_concern
    curation_concern_type.name.underscore.to_sym
  end
end
