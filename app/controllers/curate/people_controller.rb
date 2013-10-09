class Curate::PeopleController < ApplicationController
  include Sufia::Noid # for normalize_identifier method
  include Blacklight::Catalog
  include Hydra::Controller::ControllerBehavior
  

  respond_to :html
  with_themed_layout

  prepend_before_filter :normalize_identifier, only: [:show]
  before_filter :breadcrumb, only: [:show]

  configure_blacklight do |config|
    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
      qf: solr_name("desc_metadata__name", :stored_searchable),
      fl: solr_name("desc_metadata__name", :stored_searchable) + ' id',
      qt: "search",
      rows: 10
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

end
