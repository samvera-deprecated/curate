class Image < ActiveFedora::Base
  include CurationConcern::Work
  include CurationConcern::WithGenericFiles
  include CurationConcern::WithLinkedResources
  include CurationConcern::WithLinkedContributors
  include CurationConcern::WithRelatedWorks
  include CurationConcern::Embargoable
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
      validates: { presence: { message: "Your #{image_label} must have a creator." } }

    ds.attribute :date_created,
      default: Date.today.to_s("%Y-%m-%d"),
      label: "Date",
      hint: "The date or date range the item was created.",
      multiple: true,
      validates: { presence: { message: "Your #{image_label} must have a date." } }

    ds.attribute :description,
      label: "Description",
      multiple: true

    ds.attribute :category,
      label: 'Category',
      multiple: true

    ds.attribute :location,
      label: "The geographic location and/or name of the repository, building, site, or other entity whose boundaries include the Work or Image",
      multiple: true

    ds.attribute :measurements,
      label: "The physical size, shape, scale, dimensions, or format of the work or image. Dimensions may include such measurements as volume, weight, area or running time.",
      multiple: true

    ds.attribute :material,
      label: 'Material',
      multiple: true

    ds.attribute :source,
      label: 'Source',
      multiple: true

    ds.attribute :publisher,
      label: 'publisher',
      multiple: true

    ds.attribute :subject,
      label: 'Subject Keywords',
      multiple: true

    ds.attribute :inscription,
      label: 'Inscription',
      multiple: true

    ds.attribute :StateEdition,
      label: 'State Edition',
      multiple: false

    ds.attribute :textref,
      label: 'Textref',
      multiple: true

    ds.attribute :cultural_context,
      label: 'Cultural context',
      multiple: true

    ds.attribute :style_period,
      label: 'Style Period',
      multiple: true

    ds.attribute :technique,
      label: 'Technique',
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
