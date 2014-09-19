class DocumentDatastream < GenericWorkRdfDatastream
  map_predicates do |map|
    map.alternate_title(to: 'alternative', in: RDF::DC) do |index|
      index.as :stored_searchable
    end
    map.creator(to: 'creator#author', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable, :facetable
    end
    map.contributor(to: 'contributor#author', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable, :facetable
    end
    map.abstract(to: 'abstract', in: RDF::DC) do |index|
      index.as :stored_searchable
    end
    map.type(in: RDF::DC) do |index|
      index.type :text
      index.as :stored_searchable
    end
    map.repository_name(to: "contributor#repository", in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end
    map.collection_name(to: "relation#ispartof", in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end
    map.temporal_coverage({to: "temporal", in: RDF::DC}) do |index|
      index.as :stored_searchable
    end
    map.spatial_coverage({to: "spatial", in: RDF::DC}) do |index|
      index.as :stored_searchable
    end
    map.contributor_institution(to: "contributor#institution", in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end
    map.permission({in: RDF::QualifiedDC, to: 'rights#permissions'})
    map.size({to: "format#extent", in: RDF::QualifiedDC})
    map.format({in: RDF::QualifiedDC, to: 'format#mimetype'})
    map.recommended_citation({in: RDF::DC, to: 'bibliographicCitation'})
    map.identifier({to: 'identifier#doi', in: RDF::QualifiedDC}) do |index|
      index.as :stored_searchable
    end
    map.doi({to: 'identifier#doi', in: RDF::QualifiedDC})
    map.date_created(to: 'created', in: RDF::DC)
    map.date_uploaded(to: "dateSubmitted", in: RDF::DC) do |index|
      index.type :date
      index.as :stored_sortable
    end
    map.date_modified(to: "modified", in: RDF::DC) do |index|
      index.type :date
      index.as :stored_sortable
    end
  end
end
