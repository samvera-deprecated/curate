require File.expand_path('../../../lib/rdf/qualified_dc', __FILE__)
require File.expand_path('../../../lib/rdf/etd_ms', __FILE__)
require File.expand_path('../../../lib/rdf/relators', __FILE__)
class EtdMetadata < ActiveFedora::NtriplesRDFDatastream

  map_predicates do |map|
    map.title(in: RDF::DC) do |index|
      index.as :stored_searchable
    end
    map.alternate_title(to: "title#alternate", in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    map.creator(in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end

    map.contributor(in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end
    # TODO use marcrels instead
    map.contributor_role(in: RDF::EtdMs, to: 'role')


    map.advisor(in: RDF::Relators, to: 'ths')

    map.abstract(to: "description#abstract", in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    map.publisher(in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end
    map.rights(in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end
    map.note(in: RDF::QualifiedDC, to: 'description#note')

    map.format(in: RDF::QualifiedDC, to: 'format#mimetype')
    map.date_created(:to => "date#created", :in => RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end
    map.date_uploaded(to: "dateSubmitted", in: RDF::DC) do |index|
      index.type :date
      index.as :stored_searchable, :sortable
    end
    map.date_modified(to: "modified", in: RDF::DC) do |index|
      index.type :date
      index.as :stored_searchable, :sortable
    end
    map.language(in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end
    map.coverage_spatial(to: "coverage#spatial", in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable, :facetable
    end
    map.coverage_temporal(to: "coverage#temporal", in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable, :facetable
    end
    map.identifier(in: RDF::DC)
    map.doi(to: "identifier#doi", in: RDF::QualifiedDC)

    map.subject(in: RDF::DC) do |index|
      index.type :text
      index.as :stored_searchable
    end

    map.country(in: RDF::QualifiedDC, to: 'publisher#country')

    map.degree(in: RDF::EtdMs, class_name: 'Degree')

    accepts_nested_attributes_for :degree
    class Degree
      include ActiveFedora::RdfObject
      map_predicates do |map|
        map.name in: RDF::EtdMs
        map.level in: RDF::EtdMs
        map.discipline in: RDF::EtdMs
        map.grantor in: RDF::EtdMs
      end
    end
  end
end

