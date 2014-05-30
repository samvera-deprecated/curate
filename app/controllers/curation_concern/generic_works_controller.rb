class CurationConcern::GenericWorksController < CurationConcern::BaseController
  respond_to(:html)
  with_themed_layout '1_column'
  before_filter :remove_viral_files, only: [:create]

  def remove_viral_files
    good_files = []
    viral_files = []
    clam = ClamAV.instance
    content = attributes_for_actor
    unless content.nil? or content["files"].nil?
      temp_path = content["files"].instance_variable_get(:@tempfile).path
      file_name = content["files"].instance_variable_get(:@original_filename)
      scan_result = clam.scanfile(temp_path)
      
      content.each do |file|
        if (scan_result.is_a? Fixnum)
          good_files << file
        else
          viral_files << file
        end
      end

      if viral_files.any?
        flash[:error] = "The following virus #{scan_result} was found in the file (#{file_name}) you attempted to upload.  The file was not uploaded, but the work was created."
        content["files"]=nil
       end    
    end
  end

  def new
    setup_form
  end

  def create
    return unless verify_acceptance_of_user_agreement!
    if actor.create
      after_create_response
    else
      setup_form
      respond_with([:curation_concern, curation_concern]) do |wants|
        wants.html { render 'new', status: :unprocessable_entity }
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
      curation_concern.contributor << current_user.name if curation_concern.contributor.empty? && !current_user.can_make_deposits_for.any?
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
end
