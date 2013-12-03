class Curate::CollectionsController < ApplicationController
  class CollectionsControllerResource < CanCan::ControllerResource
    def initialize(*args)
      super
      if @controller.params['add_to_profile'].present?
        @options[:class] = 'ProfileSection'
      end
    end
  end
  def self.cancan_resource_class
    CollectionsControllerResource
  end

  include Blacklight::Catalog
  # Hydra::CollectionsControllerBehavior must come after Blacklight::Catalog
  # so that the update method is overridden.
  include Hydra::CollectionsControllerBehavior
  include Hydra::AccessControlsEnforcement
  include Curate::FieldsForAddToCollection
  include Sufia::Noid

  prepend_before_filter :normalize_identifier, only: [:show]

  with_themed_layout '1_column'

  add_breadcrumb 'Collections', lambda {|controller| controller.request.path }

  before_filter :authenticate_user!, except: :show
  before_filter :agreed_to_terms_of_service!
  before_filter :force_update_user_profile!

  rescue_from Hydra::AccessDenied, CanCan::AccessDenied do |exception|
    case exception.action
    when :show
      render 'unauthorized'
    when :edit
      redirect_to(collections.url_for(action: 'show'), alert: "You do not have sufficient privileges to edit this document")
    else
      if current_user and current_user.persisted?
        redirect_to root_url, alert: exception.message
      else
        session["user_return_to"] = request.url
        redirect_to new_user_session_url, alert: exception.message
      end
    end
  end

  # This applies appropriate access controls to all solr queries (the internal method of this is overidden bellow to only include edit files)
  Curate::CollectionsController.solr_search_params_logic += [:add_access_controls_to_solr_params]
  # This filters out objects that you want to exclude from search results, like FileAssets
  Curate::CollectionsController.solr_search_params_logic += [:only_collections]

  skip_load_and_authorize_resource only: [:add_member_form, :add_member, :remove_member]
  before_filter :load_and_authorize_collectible, only: [:add_member_form, :add_member]
  before_filter :load_and_authorize_collection, only: [:add_member_form, :add_member]

  def new
    @add_to_profile = params.delete(:add_to_profile)
    super
  end

  def add_member_form
    collection_options
    render 'add_member_form'
  end

  def add_member
    if @collection && @collection.add_member(@collectible)
      flash[:notice] = "\"#{@collectible}\" has been added to \"#{@collection}\""
    else
      flash[:error] = 'Unable to add item to collection.'
    end
    redirect_to params.fetch(:redirect_to) { catalog_index_path }
  end

  def remove_member
    @collection = ActiveFedora::Base.find(params[:id], cast: true)
    item = ActiveFedora::Base.find(params[:item_id], cast:true)
    @collection.remove_member(item)
    redirect_to params.fetch(:redirect_to) { collection_path(params[:id]) }
  end

  private

  def load_and_authorize_collectible
    id = id_from_params(:collectible_id)
    return nil unless id
    @collectible = ActiveFedora::Base.find(id, cast: true)
    authorize! :show, @collectible
  end

  def load_and_authorize_collection
    id = id_from_params(:collection_id)
    id ||= id_from_params(:profile_collection_id)
    return nil unless id
    @collection = ActiveFedora::Base.find(id, cast: true)
    authorize! :update, @collection
  end

  def id_from_params(key)
    if params[key] && !params[key].empty?
      params[key]
    end
  end

  def add_to_profile
    if current_user && params[:add_to_profile] == 'true'
      profile = current_user.profile
      profile.add_member(@collection) if profile
    end
  end

  def after_create
    add_to_profile
    if @collection.is_a?(ProfileSection)
      respond_to do |format|
        format.html { redirect_to user_profile_path, notice: "#{@collection.human_readable_type} was successfully created." }
        format.json { render json: @collection, status: :created, location: @collection }
      end
    else
      respond_to do |format|
        format.html { redirect_to collections_path, notice: "#{@collection.human_readable_type} was successfully created." }
        format.json { render json: @collection, status: :created, location: @collection }
      end
    end
  end

  ### Turn off this filter query if it's the index action
  def include_collection_ids(solr_parameters, user_parameters)
    return if params[:action] == 'index'
    super
  end

  def only_collections(solr_parameters, user_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "has_model_ssim:\"info:fedora/afmodel:Collection\""
    return solr_parameters
  end

  # show only files with edit permissions in lib/hydra/access_controls_enforcement.rb apply_gated_discovery
  def discovery_permissions
    ["edit"]
  end

  # Proxy engine (collections) routes to the local routes
  #  e.g. collections.collection_path(@collection)
  def collections
    self
  end

end
