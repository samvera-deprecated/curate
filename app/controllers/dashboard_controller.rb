require 'blacklight/catalog'
class DashboardController < ApplicationController
  include Hydra::BatchEditBehavior
  include Blacklight::Catalog
  include Blacklight::Configurable # comply with BL 3.7

  # This is needed as of BL 3.7; This must come before mixing in
  # BlacklightAdvancedSearch::Controller
  self.copy_blacklight_config_from(CatalogController)

  include Hydra::Controller::ControllerBehavior
  include ActionView::Helpers::DateHelper
  include BlacklightAdvancedSearch::ParseBasicQ
  include BlacklightAdvancedSearch::Controller

  with_themed_layout 'dashboard'

  before_filter :authenticate_user!
  before_filter :agreed_to_terms_of_service!
  before_filter :enforce_show_permissions, :only=>:show
  before_filter :enforce_viewing_context_for_show_requests, :only=>:show

  # This applies appropriate access controls to all solr queries (the internal method of this is overidden bellow to only include edit files)
  DashboardController.solr_search_params_logic += [:add_access_controls_to_solr_params]
  # This filters out objects that you want to exclude from search results, like FileAssets
  DashboardController.solr_search_params_logic += [:exclude_unwanted_models]

  def index
    extra_head_content << view_context.auto_discovery_link_tag(:rss, url_for(params.merge(:format => 'rss')), :title => "RSS for results")
    extra_head_content << view_context.auto_discovery_link_tag(:atom, url_for(params.merge(:format => 'atom')), :title => "Atom for results")
    (@response, @document_list) = get_search_results
    @user = current_user
    @events = @user.events(100)
    @last_event_timestamp = @user.events.first[:timestamp].to_i || 0 rescue 0
    @filters = params[:f] || []

    # adding a key to the session so that the history will be saved so that batch_edits select all will work
    search_session[:dashboard] = true
    respond_to do |format|
      format.html { save_current_search_params }
      format.rss  { render :layout => false }
      format.atom { render :layout => false }
    end

    # set up some parameters for allowing the batch controls to show appropiately
    @max_batch_size = 80
    count_on_page = @document_list.count {|doc| batch.index(doc.id)}
    @disable_select_all = @document_list.count > @max_batch_size
    batch_size = batch.uniq.size
    @result_set_size = @response.response["numFound"]
    @empty_batch = batch.empty?
    @all_checked = (count_on_page == @document_list.count)
    @entire_result_set_selected = @response.response["numFound"] == batch_size
    @batch_size_on_other_page = batch_size - count_on_page
    @batch_part_on_other_page = (@batch_size_on_other_page) > 0
  end

  def get_related_file
    @user = current_user
    #Need to make sure if params get in ways of searching (like page,per_page,q,f). If that happens then have to remove from params and put back in
    extra_controller_params = {}
    extra_controller_params.merge!(:fq=>"")
    @response, @document_list = get_solr_response_for_field_values("is_part_of_s",["info:fedora/#{params[:id]}"],extra_controller_params)
  end

  private

  def show_site_search?
    false
  end

  protected
  # show only files with edit permissions in lib/hydra/access_controls_enforcement.rb apply_gated_discovery
  def discovery_permissions
    ["edit"]
  end

  def exclude_unwanted_models(solr_parameters, user_parameters)
    super
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "-has_model_s:\"info:fedora/afmodel:GenericFile\""
    return solr_parameters
  end
end
