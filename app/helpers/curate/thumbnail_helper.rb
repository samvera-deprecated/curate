module Curate::ThumbnailHelper

  def thumbnail_image_tag_for(document)
    begin
      if document.is_a?(Collection) or  document.is_a?(Person)
        return document.representative_image_url
      elsif document.respond_to?(:representative)
        return download_path(document.representative, {:datastream_id => 'thumbnail'})
      else
        return download_path(document, {:datastream_id => 'thumbnail'})
      end
    rescue
      return download_path(document, {:datastream_id => 'thumbnail'})
    end

  end

end