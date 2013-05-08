#require 'datastreams/properties_datastream'
#require_relative './generic_file'
require 'curation_concern/model'
class SeniorThesis < ActiveFedora::Base
  include CurationConcern::Model
  include CurationConcern::WithGenericFiles
  include CurationConcern::Embargoable
  include CurationConcern::WithAccessRight

  self.human_readable_short_description = "PDFs and other Documents for your Senior Thesis"

  has_metadata name: "descMetadata", type: SeniorThesisMetadataDatastream, control_group: 'M'

  delegate_to(
    :descMetadata,
    [
      :title,
      :created,
      :description,
      :date_uploaded,
      :date_modified,
      :available,
      :archived_object_type,
      :content_format,
      :identifier,
      :rights,
      :date_created
    ],
    unique: true
  )
  delegate_to(
    :descMetadata,
    [
      :publisher,
      :bibliographic_citation,
      :source,
      :language,
      :extent,
      :requires,
      :subject
    ]
  )

  validates :title, presence: { message: 'Your must have a title.' }
  validates :rights, presence: { message: 'You must select a license for your work.' }
  validates :creator, presence: { message: "You must have an author."}

  attr_accessor :files, :assign_doi

  def contributor=(values)
    @contributor = parse_person_name(values)
    datastreams['descMetadata'].contributor = @contributor
    @contributor
  end

  def contributor
    @contributor ||= parse_person_name(datastreams['descMetadata'].contributor)
  end

  def creator=(values)
    @creator = parse_person_name(values)
    datastreams['descMetadata'].creator = @creator
    @creator
  end

  def creator
    @creator ||= parse_person_name(datastreams['descMetadata'].creator)
  end

  def doi_url
    File.join(Rails.configuration.doi_url, self.identifier)
  end

  private
  def parse_person_name(values)
    Array(values).each_with_object([]) {|value, collector|
      Namae.parse(value).each {|name|
        collector << normalize_contributor(name)
      }
    }
  end

  def normalize_contributor(name)
    [
      name.appellation,
      name.title,
      name.given,
      name.dropping_particle,
      name.nick,
      name.particle,
      name.family,
      name.suffix
    ].flatten.compact.join(" ")
  end

end
