module ApplicationHelper
  # This is included to hopefully catch most of the sufia method calls that are
  # vestigal for the Sufia engine being included in the Gemfile but unmounted.
  def sufia
    self
  end
end
