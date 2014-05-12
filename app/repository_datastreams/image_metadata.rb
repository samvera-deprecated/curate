require File.expand_path('../../../lib/rdf/qualified_dc', __FILE__)
require File.expand_path('../../../lib/rdf/image', __FILE__)
class ImageMetadata < ActiveFedora::NtriplesRDFDatastream
  map_predicates do |map|
    map.title(in: RDF::DC) do |index|
      index.as :stored_searchable
    end

    map.alternate_title(to: 'alternative', in: RDF::DC) do |index|
      index.as :stored_searchable
    end

    map.creator(in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end

    map.contributor(in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end

    map.date_created(:to => "created", :in => RDF::DC) do |index|
      index.as :stored_searchable
    end

    map.description(in: RDF::DC) do |index|
      index.as :stored_searchable
    end

    # map.location(in: RDF::Image)
    # map.category(in: RDF::Image)
    # map.measurements(in: RDF::Image)
    # map.material(in: RDF::Image)
    map.source(in: RDF::DC)
    # map.inscription(in: RDF::Image)
    # map.StateEdition(in: RDF::Image)
    # map.textref(to: 'TEXTREF', in: RDF::Image)
    # map.cultural_context(in: RDF::Image)
    # map.style_period(in: RDF::Image)
    # map.technique(in: RDF::Image)

    map.publisher(in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end
    map.rights(in: RDF::DC) do |index|
      index.as :stored_searchable
    end
    map.format(in: RDF::QualifiedDC, to: 'format#mimetype')
    map.date_uploaded(to: "dateSubmitted", in: RDF::DC) do |index|
      index.type :date
      index.as :stored_sortable
    end
    map.date_modified(to: "modified", in: RDF::DC) do |index|
      index.type :date
      index.as :stored_sortable
    end
    map.identifier({to: 'identifier#doi', in: RDF::QualifiedDC}) do |index|
      index.as :stored_searchable
    end
    map.doi(to: "identifier#doi", in: RDF::QualifiedDC)

    map.subject(in: RDF::DC) do |index|
      index.as :stored_searchable
    end

    map.type(in: RDF::DC)

    map.recommended_citation({in: RDF::DC, to: 'bibliographicCitation'})

    map.repository_name(to: "contributor#repository", in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    map.collection_name(to: "relation#ispartof", in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    map.spatial_coverage({to: "spatial", in: RDF::DC}) do |index|
      index.as :stored_searchable
    end

    map.temporal_coverage({to: "temporal", in: RDF::DC}) do |index|
      index.as :stored_searchable
    end

    map.language(in: RDF::DC)

    map.size({to: "format#extent", in: RDF::QualifiedDC})

    map.date_digitized(to: 'date#digitized', in: RDF::QualifiedDC)

    map.digitizing_equipment(to: 'description#technical', in: RDF::QualifiedDC)

    map.contributor_institution(to: "contributor#institution", in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end
    map.requires({in: RDF::DC})

  end
end

