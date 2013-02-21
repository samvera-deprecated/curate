
class SeniorThesisMetadataDatastream < ActiveFedora::NtriplesRDFDatastream
  map_predicates do |map|
    map.title(:in => RDF::DC) do |index|
      index.as :searchable, :displayable
    end
    map.contributor(:in => RDF::DC) do |index|
      index.as :searchable, :facetable, :displayable
    end
    map.created(:in => RDF::DC)
    map.creator(:in => RDF::DC) do |index|
      index.as :searchable, :facetable, :displayable
    end
    map.description(:in => RDF::DC) do |index|
      index.type :text
      index.as :searchable, :displayable
    end

    map.date_uploaded(:to => "dateSubmitted", :in => RDF::DC) do |index|
      index.type :date
      index.as :searchable, :displayable, :sortable
    end

    map.date_modified(:to => "modified", :in => RDF::DC) do |index|
      index.type :date
      index.as :searchable, :displayable, :sortable
    end

    map.part(:to => "hasPart", :in => RDF::DC)

  end
end