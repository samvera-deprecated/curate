class Curate::PeopleController < ApplicationController
  include Sufia::Noid # for normalize_identifier method
  include Blacklight::Catalog
  include Hydra::Controller::ControllerBehavior
  

  respond_to :html
  with_themed_layout

  prepend_before_filter :normalize_identifier, only: [:show]
  before_filter :breadcrumb, only: [:show]
  self.solr_search_params_logic += [:only_users]

  def self.search_config
     # Set parameters to send to SOLR
     # First inspect contents of the hash from Yaml configuration file
     # See config/search_config.yml
     initialized_config = Curate.configuration.search_config['people']
     # If the hash is empty, set reasonable defaults for this search type
     if initialized_config.nil?
        Hash['qf' => 'desc_metadata__name_tesim','fl' => 'desc_metadata__name_tesim id','qt' => 'search','rows' => 10]
     else
        initialized_config
     end
  end

  configure_blacklight do |config|
    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
      qf: search_config['qf'],
      fl: search_config['fl'],
      qt: search_config['qt'],
      rows: search_config['rows']
    }

    # solr field configuration for search results/index views
    config.index.show_link = solr_name("desc_metadata__name", :stored_searchable)
    config.index.record_display_type = "id"

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field solr_name("desc_metadata__name", :stored_searchable), label: "Name"
  end

  def person
    @person ||= Person.find(params[:id])
  end
  protected :person

  def person_has_a_name?
    person.name && !person.name.empty?
  end
  protected :person_has_a_name?

  def breadcrumb
    link_name = person_has_a_name? ? person.name : 'Person'
    add_breadcrumb link_name, person_path(person)
  end
  protected :breadcrumb

  protected

    # Limits search results just to People who have user account is param[:user] is true 
    # @param solr_parameters the current solr parameters
    # @param user_parameters the current user-subitted parameters
    def only_users(solr_parameters, user_parameters)
      solr_parameters[:fq] ||= []
      solr_parameters[:fq] << "has_user_bsi:true" if user_parameters[:user]
      return solr_parameters
    end

end
