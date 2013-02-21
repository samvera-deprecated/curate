module ApplicationHelper
  # Override to remove the label class (easier integration with bootstrap)
  # and handles arrays
  def render_facet_value_from_sufia(facet_solr_field, item, options ={})
    if item.is_a? Array
      render_array_facet_value(facet_solr_field, item, options)
    end
    path =url_for(add_facet_params_and_redirect(facet_solr_field, item.value).merge(:only_path=>true))
    (link_to_unless(options[:suppress_link], item.value, path, :class=>"facet_select") + " " + render_facet_count(item.hits)).html_safe
  end

end
