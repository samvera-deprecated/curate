class Dataset < ActiveFedora::Base
  include CurationConcern::Work
  include CurationConcern::WithGenericFiles
  include CurationConcern::WithLinkedResources
  include CurationConcern::WithLinkedContributors
  include CurationConcern::WithRelatedWorks
  include CurationConcern::Embargoable
  include CurationConcern::WithEditors

  include ActiveFedora::RegisteredAttributes

  has_metadata "descMetadata", type: DatasetMetadataDatastream

  include CurationConcern::RemotelyIdentifiedByDoi::Attributes

  class_attribute :human_readable_short_description
  self.human_readable_short_description = "One or more files related to your research."

  attribute :title, datastream: :descMetadata,
            multiple: false,
            validates: {presence: { message: 'Your dataset must have a title.' }}

  attribute :rights, datastream: :descMetadata,
            default: "All rights reserved",
            multiple: false,
            validates: {presence: { message: 'You must select a license for your dataset.' }}
  attribute :contributor, datastream: :descMetadata, multiple: true

  attribute :date_created,            datastream: :descMetadata, multiple: true, default: Date.today.to_s("%Y-%m-%d")
  attribute :date_uploaded,           datastream: :descMetadata, multiple: false
  attribute :date_modified,           datastream: :descMetadata, multiple: false
  attribute :description,             datastream: :descMetadata, multiple: false
  attribute :methodology,             datastream: :descMetadata, multiple: false
  attribute :data_processing,         datastream: :descMetadata, multiple: false
  attribute :file_structure,          datastream: :descMetadata, multiple: false
  attribute :variable_list,           datastream: :descMetadata, multiple: false
  attribute :code_list,               datastream: :descMetadata, multiple: false
  attribute :temporal_coverage,       datastream: :descMetadata, multiple: true
  attribute :spatial_coverage,        datastream: :descMetadata, multiple: true
  attribute :creator,                 datastream: :descMetadata, multiple: true
  attribute :identifier,              datastream: :descMetadata, multiple: false
  attribute :doi,                     datastream: :descMetadata, multiple: false
  attribute :permission,              datastream: :descMetadata, multiple: false
  attribute :publisher,               datastream: :descMetadata, multiple: true
  attribute :contributor_institution, datastream: :descMetadata, multiple: true
  attribute :source,                  datastream: :descMetadata, multiple: true
  attribute :language,                datastream: :descMetadata, multiple: true
  attribute :subject,                 datastream: :descMetadata, multiple: true
  attribute :recommended_citation,    datastream: :descMetadata, multiple: true
  attribute :repository_name,         datastream: :descMetadata, multiple: true
  attribute :collection_name,         datastream: :descMetadata, multiple: true
  attribute :size,                    datastream: :descMetadata, multiple: true
  attribute :requires,                datastream: :descMetadata, multiple: true

  attribute :files, multiple: true, form: {as: :file},
            hint: "CTRL-Click (Windows) or CMD-Click (Mac) to select multiple files."

end
