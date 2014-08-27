require File.expand_path('../../../lib/rdf/qualified_dc', __FILE__)
class DatasetDatastream < ActiveFedora::NtriplesRDFDatastream
  map_predicates do |map|
    map.alternate_title(to: "title#alternate", in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    map.bibliographic_citation({in: RDF::DC, to: 'bibliographicCitation'})

    map.contributor(in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end

    map.coverage_spatial({to: "coverage#spatial", in: RDF::QualifiedDC}) do |index|
      index.as :stored_searchable, :facetable
    end

    map.coverage_temporal({to: "coverage#temporal", in: RDF::QualifiedDC}) do |index|
      index.as :stored_searchable, :facetable
    end

    map.creator(in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end

    map.date_created(:to => "date#created", :in => RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    map.date_modified(to: "modified", in: RDF::DC) do |index|
      index.type :date
      index.as :stored_sortable
    end

    map.date_uploaded(to: "dateSubmitted", in: RDF::DC) do |index|
      index.type :date
      index.as :stored_sortable
    end

    map.description(in: RDF::DC) do |index|
      index.type :text
      index.as :stored_searchable
    end

    map.doi({to: "identifier#doi", in: RDF::QualifiedDC})

    map.identifier({in: RDF::DC})

    map.language({in: RDF::DC}) do |index|
      index.as :searchable, :facetable
    end

    map.note({to: 'description', in: RDF::DC})

    map.publisher({in: RDF::DC}) do |index|
      index.as :stored_searchable, :facetable
    end

    map.publisher_digital({to:"publisher#digital", in: RDF::QualifiedDC}) do |index|
      index.as :stored_searchable, :facetable
    end

    map.requires({in: RDF::DC}) ## indexing?

    map.rights(:in => RDF::DC) do |index| ## how is this different from permissions?
      index.as :stored_searchable, :facetable
    end

    map.source({in: RDF::DC})

    map.subject(in: RDF::DC) do |index|
      index.type :text
      index.as :stored_searchable
    end

    map.title(in: RDF::DC) do |index|
      index.as :stored_searchable
    end
=begin
    map.available({in: RDF::DC})
      index.as :stored_searchable, :facetable
    end

    map.access_rights({in: RDF::DC, to: 'accessRights'})

    map.content_format({in: RDF::DC, to: 'format'})
    map.extent({in: RDF::DC})

    map.part(:to => "hasPart", in: RDF::DC)
=end
  end
end

