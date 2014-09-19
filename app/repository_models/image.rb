class Image < ActiveFedora::Base
  include CurationConcern::Work
  include CurationConcern::WithGenericFiles
  include CurationConcern::WithLinkedResources
  include CurationConcern::WithRelatedWorks
  include CurationConcern::Embargoable
  include CurationConcern::WithEditors

  include ActiveFedora::RegisteredAttributes

  has_metadata "descMetadata", type: ImageMetadata

  image_label = 'image'

  include CurationConcern::RemotelyIdentifiedByDoi::Attributes

  class_attribute :human_readable_short_description
  self.human_readable_short_description = "Any image file: art, photograph, poster, etc."

  with_options datastream: :descMetadata do |ds|
    ds.attribute :title,
      label: 'Title',
      hint: "Title of the item.",
      multiple: false,
      validates: { presence: { message: "Your #{image_label} must have a title." } }

    ds.attribute :creator,
      label: "Creator",
      hint: " Primary creator/s of the item.",
      multiple: true,
      validates: { multi_value_presence: { message: "Your #{image_label} must have a creator." } }

    ds.attribute :date_created,
      default: Date.today.to_s("%Y-%m-%d"),
      label: "Date",
      hint: "The date or date range the item was created.",
      multiple: true,
      validates: { presence: { message: "Your #{image_label} must have a date." } }

    ds.attribute :description,
      label: "Description",
      multiple: true

    ds.attribute :alternate_title,
      label: "Alternate Title",
      multiple: true

    ds.attribute :contributor,
      label: "Contributor",
      multiple: true

    ds.attribute :contributor_institution,
      label: "Contributor Institution",
      multiple: true

    ds.attribute :source,
      label: 'Source',
      multiple: true

    ds.attribute :publisher,
      label: 'publisher',
      multiple: true

    ds.attribute :date_digitized,
      label: 'Date Digitized',
      multiple: true

    ds.attribute :recommended_citation,
      label: 'Recommended Citation',
      multiple: true

    ds.attribute :repository_name,
      label: 'Repository Name',
      multiple: true

    ds.attribute :collection_name,
      label: 'Collection Name',
      multiple: true

    ds.attribute :temporal_coverage,
      label: 'Temporal Coverage',
      multiple: true

    ds.attribute :spatial_coverage,
      label: 'Spatial Coverage',
      multiple: true

    ds.attribute :digitizing_equipment,
      label: 'Digitizing Equipment',
      multiple: true

    ds.attribute :language,
      label: 'Language',
      multiple: true

    ds.attribute :size,
      label: 'Size',
      multiple: true

    ds.attribute :requires,
      label: 'Requires',
      multiple: true

    ds.attribute :subject,
      label: 'Subject Keywords',
      multiple: true

    ds.attribute :date_uploaded,
      multiple: false

    ds.attribute :date_modified,
      multiple: false

    ds.attribute :rights,
      default: "All rights reserved",
      multiple: false

    ds.attribute :identifier,
      multiple: false,
      editable: false

    ds.attribute :doi,
      multiple: false,
      editable: false
  end

  attribute :files,
    multiple: true, form: {as: :file}, label: "Upload Files",
    hint: "CTRL-Click (Windows) or CMD-Click (Mac) to select multiple files."

end
