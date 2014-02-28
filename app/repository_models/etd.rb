class Etd < ActiveFedora::Base
  include CurationConcern::Work
  include CurationConcern::WithGenericFiles
  include CurationConcern::WithLinkedResources
  include CurationConcern::WithLinkedContributors
  include CurationConcern::WithRelatedWorks
  include CurationConcern::Embargoable
  include ActiveFedora::RegisteredAttributes

  has_metadata "descMetadata", type: EtdMetadata

  include CurationConcern::RemotelyIdentifiedByDoi::Attributes

  etd_label = human_readable_type.downcase

  class_attribute :human_readable_short_description
  self.human_readable_short_description = "Deposit a senior thesis, master's thesis, or dissertation."

  def self.human_readable_type
    'ETD'
  end

  has_attributes :degree, datastream: :descMetadata, multiple: true

  self.indefinite_article = 'an'
  self.contributor_label = 'Author'
  validates_presence_of :contributors, message: "Your #{human_readable_type.downcase} must have #{label_with_indefinite_article}."

  with_options datastream: :descMetadata do |ds|
    ds.attribute :contributor,
      multiple: true,
      label: "Contributor(s)",
      hint: "Who else played a non-primary role in the creation of your #{etd_label}."
    ds.attribute :contributor_role,
      multiple: true,
      label: "Contributor role(s)",
      hint: "The nature of the person or entity's contribution to the #{etd_label}. Examples: co-author, committee member, chair, co-chair, referee, juror."
    ds.attribute :title,
      label: 'Title',
      hint: "Title of the work as it appears on the title page or equivalent",
      multiple: false,
      validates: { presence: { message: "Your #{etd_label} must have a title." } }
    ds.attribute :alternate_title,
      label: "Alternate title",
      multiple: false
    ds.attribute :subject,
      label: "Subject",
      hint: "The topic of the content of the #{etd_label}.",
      multiple: true,
      validates: { presence: { message: "Your #{etd_label} must have a subject." } }
    ds.attribute :abstract,
      label: "Full text of the abstract",
      multiple: false,
      validates: { presence: { message: "Your #{etd_label} must have an abstract" } }
    ds.attribute :country,
      label: "Country",
      hint: "The country in which the #{etd_label} was originally published or accepted.",
      multiple: false,
      validates: { presence: { message: "Your #{etd_label} must have a country." } }
    ds.attribute :advisor,
      label: "Advisor",
      hint: "Advisor(s) to the thesis author.",
      multiple: true,
      validates: { presence: { message: "Your #{etd_label} must have an advisor." } }
    ds.attribute :date_created,
      default: Date.today.to_s("%Y-%m-%d"),
      label: "Date",
      hint: "The date that appears on the title page or equivalent of the #{etd_label}.",
      multiple: false,
      validates: { presence: { message: "Your #{etd_label} must have a date." } }
    ds.attribute :date_uploaded,
      multiple: false
    ds.attribute :date_modified, 
      multiple: false
    # ds.attribute :degree,
    #   label: "Degree name",
    #   hint: "Name of the degree associated with the work as it appears within the work. Example: Masters in Operations Research",
    #   multiple: false,
    #   validates: { presence: { message: "Your #{etd_label} must have a degree." } }
    # ds.attribute :degree_level,
    #   label: "Degree level",
    #   multiple: false,
    #   validates: { presence: { message: "Your #{etd_label} must have a degree level." } }
    #   #In ETD-MS, three levels are valid: 0 Undergraduate (pre-masters) 1 Masters (pre-doctoral) 2 Doctoral (includes post-doctoral)
    # ds.attribute :department,
    #   label: "Department or Program",
    #   multiple: false,
    #   hint: "Name of the department or program with which the author is affiliated."
    # ds.attribute :institution,
    #   multiple: false,
    #   hint: "Institution granting the degree associated with the work."
    ds.attribute :language,
      hint: "What is the language(s) in which you wrote your #{etd_label}?",
      default: ['English'],
      multiple: true
    ds.attribute :rights,
      default: "All rights reserved",
      multiple: false,
      validates: { presence: { message: "You must select a license for your #{etd_label}." } }
    ds.attribute :note,
      label: "Note",
      multiple: false,
      hint: " Additional information regarding the thesis. Example: acceptance note of the department"
    ds.attribute :publisher,
      hint: "An entity responsible for making the resource available. This is typically the group most directly responsible for digitizing and/or archiving the work.",
      multiple: true
    ds.attribute :coverage_temporal,
      multiple: true,
      label: "Coverage Temporal",
      hint: " The overall time frame related to the materials if applicable."
    ds.attribute :coverage_spatial,
      multiple: true,
      label: "Coverage Spatial",
      hint: " The general region that the materials are related to when applicable."
    ds.attribute :identifier,
      multiple: false,
      editable: false
    ds.attribute :format,
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
