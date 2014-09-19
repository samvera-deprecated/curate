# This module is used for any custom changes we need for all Solr queries.
# These methods can be included in the catalog_controller.rb like so:
# CatalogController.solr_search_params_logic += [:enforce_embargo]

module Hydramata::SolrHelper

  # Enforce embargo for all Solr queries
  def enforce_embargo(solr_parameters, user_parameters)
    solr_parameters[:fq] ||= []

    # Include Solr docs where the embargo is not in effect,
    # OR the embargo is in effect and the user belongs to a group with access,
    # OR the embargo is in effect and the current user is depositor

    # logged-in
    if current_user.present?

      unless current_user.manager?
        group_query = ""

        # Used to build the group access portion of the query
        current_user.person.groups.each_with_index {|group, index|
          escaped_pid = group.pid.gsub(":", "\\:")

          if index != 0
            group_query << "OR "
          end

          group_query << "discover_access_group_ssim:#{escaped_pid} OR read_access_group_ssim:#{escaped_pid} OR edit_access_group_ssim:#{escaped_pid} "

        }

        if group_query.present?
          embargo_query = "(*:* NOT embargo_release_date_dtsi:[NOW TO *]) OR (embargo_release_date_dtsi:[NOW TO *] AND (#{group_query})) OR (embargo_release_date_dtsi:[NOW TO *] AND depositor_tesim:#{current_user.user_key})"

        # User doesn't have groups to query
        else
          embargo_query = "(*:* NOT embargo_release_date_dtsi:[NOW TO *]) OR (embargo_release_date_dtsi:[NOW TO *] AND depositor_tesim:#{current_user.user_key})"

        end
      end

    # not logged-in
    else
      embargo_query = "(*:* NOT embargo_release_date_dtsi:[NOW TO *])"
    end
    solr_parameters[:fq] << embargo_query unless embargo_query.nil?
  end

end
