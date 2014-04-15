module Curate::ThumbnailHelper

  def thumbnail_image_tag_for(document)
    begin
      if document.is_a?(Collection) or  document.is_a?(Person)
        return document.representative_image_url
      else
        path = document.respond_to?(:representative) ?
                    download_path(document.representative, {:datastream_id => 'thumbnail'})
                  : download_path(document, {:datastream_id => 'thumbnail'})
        return path
      end
    rescue
      return download_path(document, {:datastream_id => 'thumbnail'})
    end

  end

end