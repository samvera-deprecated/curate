module CommonObjectsHelper
  def common_object_partial_for(object)
    object.to_partial_path.sub(/\A.*\/([^\/]*)\Z/,'common_objects/\1')
  end
end