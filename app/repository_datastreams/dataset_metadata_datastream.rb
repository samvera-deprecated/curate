class DatasetMetadataDatastream < GenericWorkRdfDatastream
  map_predicates do |map|
    map.identifier({to: 'identifier#doi', in: RDF::QualifiedDC})

    map.doi({to: 'identifier#doi', in: RDF::QualifiedDC})

    map.date_created(to: 'created', in: RDF::DC)

    map.methodology(to: 'description#methodology', in: RDF::QualifiedDC)

    map.data_processing(to: 'description#data_processing', in: RDF::QualifiedDC)

    map.file_structure(to: 'description#file_structure', in: RDF::QualifiedDC)

    map.variable_list(to: 'description#variable_list', in: RDF::QualifiedDC)

    map.code_list(to: 'description#code_list', in: RDF::QualifiedDC)

    map.recommended_citation({in: RDF::DC, to: 'bibliographicCitation'})

    map.temporal_coverage({in: RDF::DC, to: 'temporal'})

    map.spatial_coverage({in: RDF::DC, to: 'spatial'})

    map.contributor_institution(to: 'contributor#institution', in: RDF::QualifiedDC)

    map.permissions(to: 'rights#permissions', in: RDF::QualifiedDC)
  end
end

