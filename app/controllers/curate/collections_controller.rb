class Curate::CollectionsController < ApplicationController
  include Hydra::CollectionsControllerBehavior
  include Blacklight::Catalog
  with_themed_layout '1_column'

  add_breadcrumb 'Collections', lambda {|controller| controller.request.path }

  before_filter :authenticate_user!
  before_filter :agreed_to_terms_of_service!
  before_filter :force_update_user_profile!

  # This applies appropriate access controls to all solr queries (the internal method of this is overidden bellow to only include edit files)
  Curate::CollectionsController.solr_search_params_logic += [:add_access_controls_to_solr_params]
  # This filters out objects that you want to exclude from search results, like FileAssets
  Curate::CollectionsController.solr_search_params_logic += [:only_collections]

  private

  def after_create
    respond_to do |format|
      format.html { redirect_to collections_path, notice: 'Collection was successfully created.' }
      format.json { render json: @collection, status: :created, location: @collection }
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
end

