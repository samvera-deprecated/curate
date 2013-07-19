require 'hydra/head' unless defined? Hydra

if Hydra.respond_to?(:configure)
  Hydra.configure(:shared) do |config|
    # This specifies the solr field names of permissions-related fields.
    # You only need to change these values if you've indexed permissions by some means other than the Hydra's built-in tooling.
    # If you change these, you must also update the permissions request handler in your solrconfig.xml to return those values
    indexer = Solrizer::Descriptor.new(:string, :stored, :indexed, :multivalued)
    config[:permissions] = {
      :discover => {:group =>ActiveFedora::SolrService.solr_name("discover_access_group", indexer), :individual=>ActiveFedora::SolrService.solr_name("discover_access_person", indexer)},
      :read => {:group =>ActiveFedora::SolrService.solr_name("read_access_group", indexer), :individual=>ActiveFedora::SolrService.solr_name("read_access_person", indexer)},
      :edit => {:group =>ActiveFedora::SolrService.solr_name("edit_access_group", indexer), :individual=>ActiveFedora::SolrService.solr_name("edit_access_person", indexer)},
      :owner => ActiveFedora::SolrService.solr_name("depositor", indexer),
      :embargo_release_date => ActiveFedora::SolrService.solr_name("embargo_release_date", Solrizer::Descriptor.new(:date, :stored, :indexed))
    }
  end
end
