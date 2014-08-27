class Image < ActiveFedora::Base
  include CurationConcern::Work
  include CurationConcern::WithGenericFiles
  include CurationConcern::WithLinkedResources
  include CurationConcern::WithRelatedWorks
  include CurationConcern::Embargoable
  include CurationConcern::WithEditors

  include ActiveFedora::RegisteredAttributes

  has_metadata "descMetadata", type: ImageMetadata

  include CurationConcern::RemotelyIdentifiedByDoi::Attributes

  class_attribute :human_readable_short_description
  self.human_readable_short_description = "Any image file: art, photograph, poster, etc."

  with_options datastream: :descMetadata do |ds|
    ds.attribute :title,
      multiple: false,
      validates: { presence: { message: "You must have a title." } }

    ds.attribute :alternate_title,
      multiple: true

    ds.attribute :bibliographic_citation,
      multiple: false

    ds.attribute :creator,
      multiple: true,
      validates: { multi_value_presence: { message: "You must have a creator." } }

    ds.attribute :date_created,
      default: Date.today.to_s("%Y-%m-%d"),
      multiple: true,
      validates: { presence: { message: "You must have a date." } }

    ds.attribute :description,
      multiple: true

    ds.attribute :location,
      multiple: true

    ds.attribute :measurements,
      multiple: true

    ds.attribute :material,
      multiple: true

    ds.attribute :source,
      multiple: true

    ds.attribute :publisher,
      multiple: false

    ds.attribute :subject,
      multiple: true

    ds.attribute :type,
       multiple: true

    ds.attribute :inscription,
      multiple: true

    ds.attribute :date_uploaded,
      multiple: false,
      default: Date.today.to_s("%Y-%m-%d")

    ds.attribute :date_modified,
      multiple: false

    ds.attribute :date_photographed,
      multiple: false

    ds.attribute :cultural_context,
      multiple: true

    ds.attribute :rights,
      default: "All rights reserved",
      multiple: false

    ds.attribute :identifier,
      multiple: false,
      editable: false

    ds.attribute :doi,
      multiple: false,
      editable: false

    ds.attribute :contributor,
      multiple: true

    ds.attribute :coverage_spatial,
      multiple: true

    ds.attribute :coverage_temporal,
      multiple: true
  
    ds.attribute :note,
      multiple: false,
      editable: true

    ds.attribute :publisher_digital,
      default: "University of Cincinnati",
      multiple: false,
      editable: true
  
    ds.attribute :requires,
      multiple: false
  end

  attribute :files,
    multiple: true, form: {as: :file}, label: "Upload Files"

end
