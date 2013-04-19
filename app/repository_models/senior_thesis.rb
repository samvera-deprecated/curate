#require 'datastreams/properties_datastream'
#require_relative './generic_file'
require 'curation_concern/model'
class SeniorThesis < ActiveFedora::Base
  include CurationConcern::Model
  include CurationConcern::WithGenericFiles
  include CurationConcern::Embargoable
  include CurationConcern::WithAccessRight

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
      :creator,
      :content_format,
      :identifier,
      :rights
    ],
    unique: true
  )
  delegate_to(
    :descMetadata,
    [
      :contributor,
      :publisher,
      :bibliographic_citation,
      :source,
      :language,
      :extent,
      :requires,
      :subject
    ]
  )

  validates :title, presence: { message: 'Your thesis must have a title.' }
  validates :description, presence: { message: 'Your thesis must have abstract.' }
  validates :rights, presence: { message: 'You must select a license for your work.' }

  attr_accessor :thesis_file, :assign_doi

  def doi_url
    File.join(Rails.configuration.doi_url, self.identifier)
  end

end
