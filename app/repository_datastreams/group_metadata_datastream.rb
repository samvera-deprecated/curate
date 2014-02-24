require File.expand_path('../../../lib/rdf/qualified_dc', __FILE__)
class GroupMetadataDatastream < ActiveFedora::NtriplesRDFDatastream
  map_predicates do |map|
    map.title(in: RDF::DC) do |index|
      index.as :stored_searchable
    end
    map.description(:in => RDF::DC) do |index|
      index.type :text
      index.as :stored_searchable
    end
    map.date_uploaded(:to => "dateSubmitted", :in => RDF::DC) do |index|
      index.type :date
      index.as :stored_sortable
    end
    map.date_modified(:to => "modified", :in => RDF::DC) do |index|
      index.type :date
      index.as :stored_sortable
    end
  end
end
