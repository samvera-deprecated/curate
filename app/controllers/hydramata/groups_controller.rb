class Hydramata::GroupsController < ApplicationController
  include Sufia::Noid
  include Blacklight::Catalog
  include Hydra::AccessControlsEnforcement
  include Hydramata::GroupMembershipActionParser

  prepend_before_filter :normalize_identifier, only: [:show, :edit, :update]
  Hydramata::GroupsController.solr_search_params_logic += [:only_groups]
  Hydramata::GroupsController.solr_search_params_logic += [:add_access_controls_to_solr_params]
  respond_to(:html)
  with_themed_layout '1_column'

  add_breadcrumb 'Groups', lambda {|controller| controller.request.path }
  before_filter :load_and_authorize_group_for_read, only: [:show]
  before_filter :load_and_authorize_group, only: [:edit, :delete, :update, :destroy]
  before_filter :authenticate_user!
  before_filter :agreed_to_terms_of_service!
  before_filter :force_update_user_profile!

  def index
    super
  end

  def new
    @group = Hydramata::Group.new
  end

  def create
    @group = Hydramata::Group.new(params[:hydramata_group])
    @group.apply_depositor_metadata(current_user.user_key)
    if @group.save
      @group.add_member(current_user.person, 'editor')
      flash[:notice] = "Group created successfully."
      redirect_to hydramata_groups_path
    else
      flash[:error] = "Group was not created."
      render action: :new
    end
  end

  def edit
    @group = Hydramata::Group.find( params[:id] )
    @group.members.build
    respond_with(@group)
  end

  def update
    group_membership = Hydramata::GroupMembershipForm.new( Hydramata::GroupMembershipActionParser.convert_params(params) )
    if group_membership.save
      flash[:notice] = "Group updated successfully."
      redirect_to hydramata_group_path( params[:id] )
    else
      flash[:error] = "Group was not updated."
      render action: :edit
    end
  end

  def destroy
    title = @group.to_s
    @group.destroy
    after_destroy_response(title)
  end

  def after_destroy_response(title)
    flash[:notice] = "Deleted #{title}"
    respond_with { |wants|
      wants.html { redirect_to catalog_index_path }
    }
  end

  protected :after_destroy_response

  private

  def load_and_authorize_group
    id = id_from_params(:id)
    return nil unless id
    @group = ActiveFedora::Base.find(id, cast: true)
    authorize! :update, @group
  end
  
  def load_and_authorize_group_for_read
    id = id_from_params(:id)
    return nil unless id
    @group = ActiveFedora::Base.find(id, cast: true)
    authorize! :read, @group
  end

  def id_from_params(key)
    if params[key] && !params[key].empty?
      params[key]
    end
  end

  def groups
    self
  end

  ### Turn off this filter query if it's the index action
  def include_collection_ids(solr_parameters, user_parameters)
    return if params[:action] == 'index'
    super
  end

  def only_groups(solr_parameters, user_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "has_model_ssim:\"info:fedora/afmodel:Hydramata_Group\""
    return solr_parameters
  end
end
