require File.expand_path('../../../lib/rdf/qualified_dc', __FILE__)
class ArticleMetadataDatastream < ActiveFedora::NtriplesRDFDatastream
  map_predicates do |map|
    map.abstract(to: "description#abstract", in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end
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
    map.doi({to: "identifier#doi", in: RDF::QualifiedDC})
    map.extent({to: "format#extent", in: RDF::QualifiedDC})
    map.format({in: RDF::QualifiedDC, to: 'format#mimetype'})
    map.identifier({in: RDF::DC})
    map.issn({to: "identifier#issn", in: RDF::QualifiedDC}) ## the term for this is a problem
    map.journal_title(to: "source", in: RDF::DC) do |index|
      index.type :text
      index.as :stored_searchable
    end
    map.language({in: RDF::DC}) do |index|
      index.as :stored_searchable, :facetable
    end
    map.note({to: 'description', in: RDF::DC}) ## is this the best term for this value? indexing?
    map.permissions({in: RDF::DC, to: 'accessRights'})
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
    map.subject(in: RDF::DC) do |index|
      index.type :text
      index.as :stored_searchable
    end
    map.title(in: RDF::DC) do |index|
      index.as :stored_searchable
    end
    map.type({in: RDF::DC}) ## indexing?

=begin
    map.collection_name(to: "relation#ispartof", in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end
    map.contributor_institution(to: "contributor#institution", in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end
    map.date_digitized(to: "date#digitized", in: RDF::QualifiedDC) do |index|
      index.type :date
      index.as :stored_searchable, :sortable
    end
    map.digitizing_equipment({to: "description#technical", in: RDF::QualifiedDC}) do |index|
      index.as :stored_searchable, :facetable
    end
    map.repository_name(to: "contributor#repository", in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end
=end

  end
end
