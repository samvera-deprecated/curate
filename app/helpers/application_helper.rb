module ApplicationHelper
  # This is included to hopefully catch most of the sufia method calls that are
  # vestigal for the Sufia engine being included in the Gemfile but unmounted.
  def sufia
    self
  end

  def construct_page_title(*elements)
    (elements.flatten.compact + [application_name]).join(" // ")
  end

  def curation_concern_page_title(curation_concern)
    if curation_concern.persisted?
      construct_page_title(curation_concern.title, "#{curation_concern.human_readable_type} [#{curation_concern.to_param}]")
    else
      construct_page_title("New #{curation_concern.human_readable_type}")
    end
  end

  def default_page_title
    text = controller_name.singularize.titleize
    if action_name
      text = "#{action_name.titleize} " + text
    end
    construct_page_title(text)
  end

  def curation_concern_attribute_to_html(curation_concern, method_name, label)
    markup = ""
    if curation_concern.send(method_name).count > 0
      markup << %(<dt>#{label}</dt>\n)
      curation_concern.send(method_name).each do |value|
        markup << %(<dd class="attribute #{method_name}">#{h(value)}</dd>\n)
      end
    end
    markup.html_safe
  end

  def classify_for_display(curation_concern)
    curation_concern.human_readable_type.downcase
  end

  def bootstrap_navigation_element(name, path)
    markup = ""

    if current_page? path
      markup = <<HTML
<li class="disabled">#{link_to name, '#', tabindex: :'-1'}</li>
HTML
    else
      markup = <<HTML
<li>#{link_to name, path}</li>
HTML
    end

    markup.html_safe()
  end

  def link_to_edit_permissions(curation_concern, solr_document = nil)
    markup = <<-HTML
      <a href="#{edit_polymorphic_path([:curation_concern, curation_concern])}" id="permission_#{curation_concern.to_param}">
        #{permission_badge_for(curation_concern, solr_document)}
      </a>
    HTML
    markup.html_safe
  end

  def permission_badge_for(curation_concern, solr_document = nil)
    solr_document ||= curation_concern.to_solr
    dom_label_class, link_title = extract_dom_label_class_and_link_title(solr_document)
    %(<span class="label #{dom_label_class}" title="#{link_title}">#{link_title}</span>).html_safe
  end

  def extract_dom_label_class_and_link_title(document)
    hash = document.stringify_keys
    dom_label_class, link_title = "label-important", "Private"
    if hash['read_access_group_t'].present?
      if hash['read_access_group_t'].include?('public')
        dom_label_class, link_title = 'label-success', 'Open Access'
      elsif hash['read_access_group_t'].include?('registered')
        dom_label_class, link_title = "label-info", t('sufia.institution_name')
      end
    end
    return dom_label_class, link_title
  end
  private :extract_dom_label_class_and_link_title
end
