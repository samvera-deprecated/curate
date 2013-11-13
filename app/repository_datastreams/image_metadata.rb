require File.expand_path('../../../lib/rdf/qualified_dc', __FILE__)
require File.expand_path('../../../lib/rdf/image', __FILE__)
class ImageMetadata < ActiveFedora::NtriplesRDFDatastream
  map_predicates do |map|
    map.title(in: RDF::DC) do |index|
      index.as :stored_searchable
    end

    map.creator(in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end

    map.date_created(:to => "date#created", :in => RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    map.description(in: RDF::DC) do |index|
      index.as :stored_searchable
    end

    map.location(in: RDF::Image)
    map.category(in: RDF::Image)
    map.measurements(in: RDF::Image)
    map.material(in: RDF::Image)
    map.source(in: RDF::Image)
    map.inscription(in: RDF::Image)
    map.StateEdition(in: RDF::Image)
    map.textref(to: 'TEXTREF', in: RDF::Image)
    map.cultural_context(in: RDF::Image)
    map.style_period(in: RDF::Image)
    map.technique(in: RDF::Image)

    map.publisher(in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end
    map.rights(in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end
    map.format(in: RDF::QualifiedDC, to: 'format#mimetype')
    map.date_uploaded(to: "dateSubmitted", in: RDF::DC) do |index|
      index.type :date
      index.as :stored_searchable, :sortable
    end
    map.date_modified(to: "modified", in: RDF::DC) do |index|
      index.type :date
      index.as :stored_searchable, :sortable
    end
    map.identifier(in: RDF::DC)
    map.doi(to: "identifier#doi", in: RDF::QualifiedDC)

    map.subject(in: RDF::DC) do |index|
      index.as :stored_searchable
    end

  end
end

