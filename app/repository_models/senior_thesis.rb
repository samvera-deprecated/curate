#require 'datastreams/properties_datastream'
#require_relative './generic_file'
class SeniorThesis < ActiveFedora::Base
  include Hydra::ModelMixins::CommonMetadata
  include Hydra::ModelMixins::RightsMetadata
  include Sufia::ModelMethods
  include Sufia::Noid
  include Sufia::GenericFile::Permissions

  has_metadata name: "properties", type: PropertiesDatastream
  has_metadata name: "descMetadata", type: SeniorThesisMetadataDatastream

  has_many :generic_files, property: :is_part_of

  after_destroy :after_destroy_cleanup
  def after_destroy_cleanup
    generic_files.each(&:destroy)
  end

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
  delegate_to :properties, [:relative_path, :depositor], unique: true

  validates :title, presence: true
  validates :embargo_release_date, embargo: true

  #validate :valid_embargo_release_date?
  validates :rights, presence: true

  before_save {|obj| obj.archived_object_type = self.human_readable_type }

  def human_readable_type
    self.class.to_s.demodulize.titleize
  end

  before_save :write_embargo_release_date

  def write_embargo_release_date
    self.datastreams["rightsMetadata"].embargo_release_date=embargo_release_date
  end

  def to_solr(solr_doc={}, opts={})
    super(solr_doc, opts)
    solr_doc["noid_s"] = noid
    return solr_doc
  end

  attr_accessor :thesis_file, :visibility, :assign_doi, :embargo_release_date

  def to_param
    noid
  end

  def to_s
    title
  end
  def embargo_release_date=(embargo_date)
    @embargo_release_date = embargo_date
  end

  def embargo_release_date
    @embargo_release_date || self.datastreams["rightsMetadata"].embargo_release_date
  end

end
