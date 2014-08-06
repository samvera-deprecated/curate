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

  attribute :abstract,
    label: "Abstract or Summary of the Article",
    datastream: :descMetadata, multiple: false,
    validates: { presence: { message: 'Your Article must have an abstract.' } }
  attribute :alternate_title,
    datastream: :descMetadata, multiple: true
  attribute :bibliographic_citation,
    label: "Recommended Citation",
    datastream: :descMetadata, multiple: false
  attribute :contributor,
    datastream: :descMetadata, multiple: true,
    label: "Contributing Author(s)",
    hint: "Who else played a non-primary role in the creation of your Article."
  attribute :coverage_spatial,
    datastream: :descMetadata, multiple: true
  attribute :coverage_temporal,
    datastream: :descMetadata, multiple: true
  attribute :creator,
    datastream: :descMetadata, multiple: false,
    label: "Author",
    hint: "Primary creator/s of the article.",
    validates: { multi_value_presence: { message: "Your article must have an author." } }
  attribute :date_created,
    default: Date.today.to_s("%Y-%m-%d"),
    label: "When did your finish your Article",
    hint: "This does not need to be exact, but your best guess.",
    datastream: :descMetadata, multiple: false
  attribute :date_modified, 
    datastream: :descMetadata, multiple: false
  attribute :date_uploaded,
    datastream: :descMetadata, multiple: false
  attribute :doi,
    datastream: :descMetadata, multiple: false,
    editable: false
  ## extent - does this belong to works?
  attribute :content_format,
    label: "Content Format",
    datastream: :descMetadata, multiple: true
  attribute :identifier,
    datastream: :descMetadata, multiple: true,
    editable: false
  attribute :issn,
    datastream: :descMetadata, multiple: false,
    editable: true
  attribute :journal_title,
    label: "Journal Title",
    datastream: :descMetadata, multiple: false
  attribute :language,
    hint: "What is the language(s) in which you wrote your work?",
    default: ['English'],
    datastream: :descMetadata, multiple: true
  attribute :note,
    datastream: :descMetadata, multiple: false,
    editable: true
  ## permissions - same as rights?
  attribute :publisher,
    datastream: :descMetadata, multiple: false,
    editable: true
  attribute :publisher_digital,
    datastream: :descMetadata, multiple: false,
    editable: true
  attribute :requires,
    datastream: :descMetadata, multiple: false
  attribute :rights,
    datastream: :descMetadata, multiple: false,
    default: "All rights reserved",
    validates: { presence: { message: 'You must select a license for your work.' } }
  attribute :subject,
    label: "Keyword(s) or phrase(s)",
    hint: "What words or phrases would be helpful for someone searching for your Article",
    datastream: :descMetadata, multiple: true
  attribute :title,
    datastream: :descMetadata, multiple: false,
    label: "Title of your Article",
    validates: { presence: { message: 'Your article must have a title.' } }
  ## type

  attribute :files,
    multiple: true, form: {as: :file}, label: "Upload Files",
    hint: "CTRL-Click (Windows) or CMD-Click (Mac) to select multiple files."

=begin
  attribute :repository_name,
    datastream: :descMetadata, multiple: false,
    label: "Repository Name",
    hint: "The physical location of the materials."
  attribute :contributor_institution,
    datastream: :descMetadata, multiple: false,
    label: "Contributor Institution",
    hint: "The Institution that is contributing the item to the repository."
  attribute :collection_name,
    datastream: :descMetadata, multiple: false,
    label: "Collection Name",
    hint: "The name of the collection that is being digitized."
  attribute :date_digitized,
    label: "Digitized Date",
    datastream: :descMetadata, multiple: false,
    hint: "The date the materials were digitized."
=end

end
