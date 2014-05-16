class Article < ActiveFedora::Base
  include CurationConcern::Work
  include CurationConcern::WithGenericFiles
  include CurationConcern::WithLinkedResources
  include CurationConcern::WithLinkedContributors
  include CurationConcern::WithRelatedWorks
  include CurationConcern::Embargoable
  include CurationConcern::WithEditors

  include ActiveFedora::RegisteredAttributes

  has_metadata "descMetadata", type: ArticleMetadataDatastream

  include CurationConcern::RemotelyIdentifiedByDoi::Attributes

  class_attribute :human_readable_short_description
  self.human_readable_short_description = "Deposit or reference a preprint or published article."

  self.indefinite_article = 'an'
  self.contributor_label = 'Author'

  attribute :title,
    datastream: :descMetadata, multiple: false,
    label: "Title of your Article",
    validates: { presence: { message: 'Your article must have a title.' } }
  attribute :alternate_title,
    datastream: :descMetadata, multiple: true
  attribute :creator, datastream: :descMetadata, multiple: true, validates: { multi_value_presence: true }
  attribute :contributor,
    datastream: :descMetadata, multiple: true,
    label: "Contributing Author(s)",
    hint: "Who else played a non-primary role in the creation of your Article."
  attribute :repository_name,
    datastream: :descMetadata, multiple: true,
    label: "Repository Name",
    hint: "The physical location of the materials."
  attribute :contributor_institution,
    datastream: :descMetadata, multiple: true,
    label: "Contributor Institution",
    hint: "The Institution that is contributing the item to the repository."
  attribute :collection_name,
    datastream: :descMetadata, multiple: true,
    label: "Collection Name",
    hint: "The name of the collection that is being digitized."
  attribute :abstract,
    label: "Abstract or Summary of the Article",
    datastream: :descMetadata, multiple: false,
    validates: { presence: { message: 'Your Article must have an abstract.' } }
  attribute :content_format,
    label: "Content Format",
    datastream: :descMetadata, multiple: false
  attribute :recommended_citation,
    label: "Recommended Citation",
    datastream: :descMetadata, multiple: true
  attribute :date_created,
    default: Date.today.to_s("%Y-%m-%d"),
    label: "When did your finish your Article",
    hint: "This does not need to be exact, but your best guess.",
    datastream: :descMetadata, multiple: true
  attribute :date_uploaded,
    datastream: :descMetadata, multiple: false
  attribute :date_modified, 
    datastream: :descMetadata, multiple: false
  attribute :source,
    datastream: :descMetadata, multiple: true
  attribute :subject,
    label: "Keyword(s) or phrase(s)",
    hint: "What words or phrases would be helpful for someone searching for your Article",
    datastream: :descMetadata, multiple: true
  attribute :language,
    hint: "What is the language(s) in which you wrote your work?",
    default: ['English'],
    datastream: :descMetadata, multiple: true
  attribute :publisher,
    datastream: :descMetadata, multiple: true
  attribute :spatial_coverage,
    datastream: :descMetadata, multiple: false
  attribute :temporal_coverage,
    datastream: :descMetadata, multiple: false
  attribute :identifier,
    datastream: :descMetadata, multiple: false,
    editable: false
  attribute :issn,
    datastream: :descMetadata, multiple: true,
    editable: true
  attribute :doi,
    datastream: :descMetadata, editable: true
  attribute :rights,
    datastream: :descMetadata, multiple: false,
    default: "All rights reserved",
    validates: { presence: { message: 'You must select a license for your work.' } }

  attribute :requires,
    datastream: :descMetadata, multiple: true

  attribute :size,
    datastream: :descMetadata, multiple: true

  attribute :files,
    multiple: true, form: {as: :file}, label: "Upload Files",
    hint: "CTRL-Click (Windows) or CMD-Click (Mac) to select multiple files."

end
