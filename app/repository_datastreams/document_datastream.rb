class DocumentDatastream < GenericWorkRdfDatastream
  map_predicates do |map|
    map.type(in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end
  end
end
