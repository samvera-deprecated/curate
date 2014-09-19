require File.expand_path('../../../lib/rdf/qualified_dc', __FILE__)
class DatasetMetadataDatastream < GenericWorkRdfDatastream
  map_predicates do |map|
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

    map.description(in: RDF::DC) do |index|
      index.type :text
      index.as :stored_searchable
    end

    map.methodology(to: 'description#methodology', in: RDF::QualifiedDC)

    map.data_processing(to: 'description#data_processing', in: RDF::QualifiedDC)

    map.file_structure(to: 'description#file_structure', in: RDF::QualifiedDC)

    map.variable_list(to: 'description#variable_list', in: RDF::QualifiedDC)

    map.code_list(to: 'description#code_list', in: RDF::QualifiedDC)

    map.recommended_citation({in: RDF::DC, to: 'bibliographicCitation'})

    map.temporal_coverage({in: RDF::DC, to: 'temporal'})

    map.spatial_coverage({in: RDF::DC, to: 'spatial'})

    map.contributor_institution(to: 'contributor#institution', in: RDF::QualifiedDC)

    map.permission(to: 'rights#permissions', in: RDF::QualifiedDC)

    map.repository_name(to: "contributor#repository", in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    map.collection_name(to: "relation#ispartof", in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    map.size({to: "format#extent", in: RDF::QualifiedDC})
  end
end

