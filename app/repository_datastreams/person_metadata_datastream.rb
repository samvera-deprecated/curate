require File.expand_path('../../../lib/rdf/qualified_foaf', __FILE__)
class PersonMetadataDatastream < ActiveFedora::NtriplesRDFDatastream
  map_predicates do |map|
    map.name(to: "name", in: RDF::FOAF) do |index|
      index.as :stored_searchable, :displayable
    end

    map.title(to: "title", in: RDF::FOAF) do |index|
      index.as :stored_searchable, :displayable
    end

    map.campus_phone_number(to: "phone#campus_phone_number", in: RDF::QualifiedFOAF) do |index|
      index.as :stored_searchable, :displayable
    end

    map.alternate_phone_number(to: "phone#alternate_phone_number", in: RDF::QualifiedFOAF) do |index|
      index.as :stored_searchable, :displayable
    end

    map.date_of_birth(to: "birthday", in: RDF::FOAF) do |index|
      index.as :stored_searchable, :displayable
    end

    map.personal_webpage(to: "homepage", in: RDF::FOAF) do |index|
      index.as :stored_searchable, :displayable
    end

    map.blog(to: "weblog", in: RDF::FOAF) do |index|
      index.as :stored_searchable, :displayable
    end

    map.gender(to: "gender", in: RDF::FOAF) do |index|
      index.as :stored_searchable, :displayable
    end

    map.based_near(to: "based_near", in: RDF::FOAF) do |index|
      index.as :stored_searchable, :displayable
    end

    map.alternate_email(to: "account#alternate_email", in: RDF::QualifiedFOAF) do |index|
      index.as :stored_searchable, :displayable
    end

    map.preferred_email(to: "account#preferred_email", in: RDF::QualifiedFOAF) do |index|
      index.as :stored_searchable, :displayable
    end
  end
end
