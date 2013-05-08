require 'lib/rdf/qualified_dc'
class SeniorThesisMetadataDatastream < ActiveFedora::NtriplesRDFDatastream
  map_predicates do |map|
    map.title(in: RDF::DC) do |index|
      index.as :searchable, :displayable
    end
    map.contributor(in: RDF::DC) do |index|
      index.as :searchable, :displayable
    end
    map.advisor(to: "contributor#advisor", in: RDF::QualifiedDC) do |index|
      index.as :searchable, :displayable
    end
    map.created(in: RDF::DC)
    map.creator(in: RDF::DC) do |index|
      index.as :searchable, :displayable
    end
    map.description(in: RDF::DC) do |index|
      index.type :text
      index.as :searchable, :displayable
    end
    map.subject(in: RDF::DC) do |index|
      index.type :text
      index.as :searchable, :displayable
    end

    map.date_uploaded(to: "dateSubmitted", in: RDF::DC) do |index|
      index.type :date
      index.as :searchable, :displayable, :sortable
    end

    map.date_created(:to => "created", :in => RDF::DC) do |index|
      index.type :date
      index.as :searchable, :displayable
    end

    map.date_modified(to: "modified", in: RDF::DC) do |index|
      index.type :date
      index.as :searchable, :displayable, :sortable
    end

    map.issued({in: RDF::DC}) do |index|
      index.as :searchable, :displayable
    end

    map.available({in: RDF::DC})
    map.publisher({in: RDF::DC}) do |index|
      index.as :searchable, :displayable, :facetable
    end

    map.bibliographic_citation({in: RDF::DC, to: 'bibliographicCitation'})
    map.source({in: RDF::DC})

    map.rights(:in => RDF::DC) do |index|
      index.as :searchable, :displayable, :facetable
    end

    map.access_rights({in: RDF::DC, to: 'accessRights'})
    map.language({in: RDF::DC}) do |index|
      index.as :searchable, :facetable
    end

    map.archived_object_type({in: RDF::DC, to: 'type'}) do |index|
      index.as :searchable, :displayable, :facetable
    end

    map.content_format({in: RDF::DC, to: 'format'})
    map.extent({in: RDF::DC})
    map.requires({in: RDF::DC})
    map.identifier({in: RDF::DC})

    map.part(:to => "hasPart", in: RDF::DC)

  end
end
