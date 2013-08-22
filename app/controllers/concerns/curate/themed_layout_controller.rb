module Curate::ThemedLayoutController
  extend ActiveSupport::Concern

  included do
    class_attribute :theme
    self.theme = 'curate_nd'
    helper_method :theme
    helper_method :show_action_bar?
    helper_method :show_site_search?
  end

  module ClassMethods
    def with_themed_layout(view_name = nil)
      if view_name
        layout("#{theme}/#{view_name}")
      else
        layout(theme)
      end
    end
  end

  def show_action_bar?
    true
  end

  def show_site_search?
    true
  end

end
