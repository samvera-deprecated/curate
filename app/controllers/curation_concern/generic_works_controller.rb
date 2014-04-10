class CurationConcern::GenericWorksController < CurationConcern::BaseController
  respond_to(:html)
  with_themed_layout '1_column'

  def new
    setup_form
  end

  def create
    if verify_acceptance_of_user_agreement!
      self.curation_concern.inner_object.pid = CurationConcern.mint_a_pid
      hash = params.dup
      params[get_class_name].delete("editors_attributes") if params.has_key?(get_class_name)
      if actor.create && add_depositor_as_editor && add_or_update_editors_and_groups(hash).save
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
    if curation_concern.respond_to?(:contributor)
      curation_concern.contributor << current_user.name if curation_concern.contributor.empty?
    end
    curation_concern.editors << current_user.person if curation_concern.editors.blank?
    curation_concern.editors.build
    curation_concern.editor_groups.build
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
    if add_or_update_editors_and_groups(params).save && actor.update
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
    after_destroy_response(title)
  end

  def after_destroy_response(title)
    flash[:notice] = "Deleted #{title}"
    respond_with { |wants|
      wants.html { redirect_to catalog_index_path }
    }
  end
  protected :after_destroy_response

  register :actor do
    CurationConcern.actor(curation_concern, current_user, attributes_for_actor)
  end

  def attributes_for_actor
    return params[hash_key_for_curation_concern] if cloud_resources_to_ingest.nil?
    params[hash_key_for_curation_concern].merge!(:cloud_resources=>cloud_resources_to_ingest)
  end

  def hash_key_for_curation_concern
    curation_concern_type.name.underscore.to_sym
  end

  private
  def add_or_update_editors_and_groups(hash=params)
    class_name = get_class_name
    hash.merge!( { id: curation_concern.pid } ) unless hash.has_key?(:id)
    req_hash = CurationConcern::WorkPermissionActionParser.convert_params(class_name, hash)
    req_hash.merge!( {current_user: current_user} )
    params[class_name].delete("editors_attributes") if params.has_key?(class_name) && params[class_name].has_key?("editors_attributes")
    params[class_name].delete("editor_groups_attributes") if params.has_key?(class_name) && params[class_name].has_key?("editor_groups_attributes")
    CurationConcern::WorkPermission.new(req_hash)
  end

  def add_depositor_as_editor
    curation_concern.add_editor(current_user.person)
  end

  def get_class_name
    curation_concern.class.to_s.underscore
  end
end
