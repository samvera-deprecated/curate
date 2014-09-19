class Collection < ActiveFedora::Base
  include Hydra::Collection
  include CurationConcern::CollectionModel
  include Hydra::Collections::Collectible
  include Hydra::Derivatives

  has_file_datastream :name => "content"
  has_file_datastream :name => "medium"
  has_file_datastream :name => "thumbnail"

  attr_accessor :mime_type
  attr_accessor :file

  makes_derivatives :generate_derivatives

  before_save :add_profile_image, :only => [ :create, :update ]

  def can_be_member_of_collection?(collection)
    collection == self ? false : true
  end

  def add_profile_image
    if file
      self.content.content = file
      self.mime_type = file.content_type
      generate_derivatives
    end
  end

  def representative_image_url
    generate_thumbnail_url if self.thumbnail.content.present?
  end

  def to_solr(solr_doc={}, opts={})
    super(solr_doc, opts)
    Solrizer.set_field(solr_doc, 'generic_type', 'Collection', :facetable)
    solr_doc[Solrizer.solr_name('representative', :stored_searchable)] = self.representative
    solr_doc[Solrizer.solr_name('representative_image_url', :stored_searchable)] = self.representative_image_url
    solr_doc
  end

  def representative
    to_param
  end

  private

  def generate_derivatives
    case mime_type
    when 'image/png', 'image/jpeg', 'image/tiff'
      transform_datastream :content, { medium: {size: "300x300>", datastream: 'medium'}, thumb: {size: "100x100>", datastream: 'thumbnail'} }
    end
  end

  def generate_thumbnail_url
    "/downloads/#{self.representative}?datastream_id=thumbnail"
  end
end
