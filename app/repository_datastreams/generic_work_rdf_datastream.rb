class GenericWorkRdfDatastream < ActiveFedora::NtriplesRDFDatastream
  map_predicates do |map|
    map.title(in: RDF::DC) do |index|
      index.as :stored_searchable
    end
    map.contributor(in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end
    map.created(in: RDF::DC)
    map.creator(in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end
    map.description(in: RDF::DC) do |index|
      index.type :text
      index.as :stored_searchable
    end
    map.subject(in: RDF::DC) do |index|
      index.type :text
      index.as :stored_searchable
    end

    map.date_uploaded(to: "dateSubmitted", in: RDF::DC) do |index|
      index.type :date
      index.as :stored_sortable
    end

    map.date_modified(to: "modified", in: RDF::DC) do |index|
      index.type :date
      index.as :stored_sortable
    end

    map.issued({in: RDF::DC}) do |index|
      index.as :stored_searchable
    end

    map.available({in: RDF::DC})
    map.publisher({in: RDF::DC}) do |index|
      index.as :stored_searchable, :facetable
    end

    map.bibliographic_citation({in: RDF::DC, to: 'bibliographicCitation'})
    map.source({in: RDF::DC})

    map.rights(:in => RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end

    map.access_rights({in: RDF::DC, to: 'accessRights'})
    map.language({in: RDF::DC}) do |index|
      index.as :searchable, :facetable
    end

    map.content_format({in: RDF::DC, to: 'format'})
    map.extent({in: RDF::DC})
    map.requires({in: RDF::DC})
    map.identifier({in: RDF::DC}) do |index|
      index.as :stored_searchable
    end

    map.part(:to => "hasPart", in: RDF::DC)
  end
end

