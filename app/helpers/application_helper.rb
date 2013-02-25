module ApplicationHelper
  # This is included to hopefully catch most of the sufia method calls that are
  # vestigal for the Sufia engine being included in the Gemfile but unmounted.
  def sufia
    self
  end

  def bootstrap_navigation_element(name, path)
    markup = ""

    if current_page? path
      markup = <<HTML
      <li class="disabled">
        #{link_to name, '#', tabindex: :'-1'}
      </li>
HTML
    else
      markup = <<HTML
      <li>
        #{link_to name, path}
      </li>
HTML
    end

    markup.html_safe()
  end
end
