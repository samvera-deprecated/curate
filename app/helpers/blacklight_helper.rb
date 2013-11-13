require Blacklight::Engine.root.join('app/helpers/blacklight/hash_as_hidden_fields_helper_behavior')
require Blacklight::Engine.root.join('app/helpers/blacklight/render_constraints_helper_behavior')
require Blacklight::Engine.root.join('app/helpers/blacklight/html_head_helper_behavior')
require Blacklight::Engine.root.join('app/helpers/blacklight/facets_helper_behavior')

require Blacklight::Engine.root.join('app/helpers/hash_as_hidden_fields_helper')
require Blacklight::Engine.root.join('app/helpers/render_constraints_helper')
require Blacklight::Engine.root.join('app/helpers/html_head_helper')
require Blacklight::Engine.root.join('app/helpers/facets_helper')

require Blacklight::Engine.root.join('app/helpers/blacklight/blacklight_helper_behavior')

module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  def application_name
    t('sufia.product_name')
  end

  # Loads the object and returns its name(for creator)/title(for collection)
  def get_value_from_pid(field, value)
    attr_value = ""
    begin
      attr_value = ActiveFedora::Base.load_instance_from_solr(value.split("/").last).name if field == "desc_metadata__creator_sim"
      attr_value = ActiveFedora::Base.load_instance_from_solr(value).title if field == "collection_sim"
    rescue => e
      logger.warn("WARN: Helper method get_value_from_pid raised an error when loading #{value}.  Error was #{e}")
    end
    return attr_value.blank? ? value : attr_value
  end
end
