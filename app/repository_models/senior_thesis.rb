require 'datastreams/properties_datastream'
require_relative './generic_file'
class SeniorThesis < ActiveFedora::Base
  include Hydra::ModelMixins::CommonMetadata
  include Hydra::ModelMixins::RightsMetadata
  include Sufia::ModelMethods
  include Sufia::Noid
  include Sufia::GenericFile::Permissions

  has_metadata :name => "properties", :type => PropertiesDatastream
  has_metadata :name => "descMetadata", :type => SeniorThesisMetadataDatastream

  has_many :generic_files, :property => :is_part_of

  delegate_to :descMetadata, [:title, :created, :description, :creator], :unique => true
  delegate_to :properties, [:relative_path, :depositor], :unique => true
  delegate_to :descMetadata, [:contributor]

  validates :title, presence: true

  def to_solr(solr_doc={}, opts={})
    super(solr_doc, opts)
    solr_doc["noid_s"] = noid
    return solr_doc
  end


  attr_writer :thesis_file
  def current_thesis_file
    generic_files.first
  end
end
