require 'active_support'

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

  # options[:include_empty]
  def curation_concern_attribute_to_html(curation_concern, method_name, label, options = {})
    markup = ""
    subject = curation_concern.send(method_name)
    return markup if !subject.present? && !options[:include_empty]
    markup << %(<tr><th>#{label}</th>\n<td><ul class='tabular'>)
    [subject].flatten.compact.each do |value|
      markup << %(<li class="attribute #{method_name}">#{h(value)}</li>\n)
    end
    markup << %(</ul></td></tr>)
    markup.html_safe
  end

  def classify_for_display(curation_concern)
    curation_concern.human_readable_type.downcase
  end

  def bootstrap_navigation_element(name, path, options = {})
    a_tag_options = options.delete(:a_tag_options) || {}
    path_to_use = path
    if current_page? path
      options[:class] ||= ''
      options[:class] << ' active'
      a_tag_options[:tabindex] ||= :'-1'
      path_to_use = '#'
    end
    content_tag('li', options) {
      link_to name, path_to_use, a_tag_options
    }.html_safe
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
        if hash['embargo_release_date_dt'].present?
          dom_label_class, link_title = 'label-warning', 'Open Access with Embargo'
        else
          dom_label_class, link_title = 'label-success', 'Open Access'
        end
      elsif hash['read_access_group_t'].include?('registered')
        dom_label_class, link_title = "label-info", t('sufia.institution_name')
      end
    end
    return dom_label_class, link_title
  end
  private :extract_dom_label_class_and_link_title
end
