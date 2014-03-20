# This module is used for any custom changes we need for all Solr queries.
# These methods can be included in the catalog_controller.rb like so:
# CatalogController.solr_search_params_logic += [:enforce_embargo]

module Hydramata::SolrHelper

  # Enforce embargo for all Solr queries
  def enforce_embargo(solr_parameters, user_parameters)
    solr_parameters[:fq] ||= []
    
    # include docs in results if the embargo date is NOT in the future OR if the current user is depositor
    if current_user.present?
      embargo_query = "(NOT embargo_release_date_dtsi:[NOW TO *]) OR (embargo_release_date_dtsi:[NOW TO *] AND depositor_tesim:#{current_user.email}) AND NOT (NOT depositor_tesim:#{current_user.email} AND embargo_release_date_dtsi:[NOW TO *])"
    else
      embargo_query = "NOT embargo_release_date_dtsi:[NOW TO *]"
    end

    solr_parameters[:fq] << embargo_query
  end

end