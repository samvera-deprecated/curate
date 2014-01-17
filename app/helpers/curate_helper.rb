module CurateHelper

  # Loads the object and returns its title
  def collection_title_from_pid  value
    begin
      c = Collection.load_instance_from_solr(value)
    rescue => e
      logger.warn("WARN: Helper method collection_title_from_pid raised an error when loading #{value}.  Error was #{e}")
    end
    return c.nil? ? value : c.title
  end

  # Loads the person object and returns their name
  # In this case, the value is in the format: info:fedora/<PID>
  # So used split
  def creator_name_from_pid value
    begin
      p = Person.load_instance_from_solr(value.split("/").last)
    rescue => e
      logger.warn("WARN: Helper method create_name_from_pid raised an error when loading #{value}.  Error was #{e}")
    end
    return p.nil? ? value : p.name
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
  def curation_concern_attribute_to_html(curation_concern, method_name, label = nil, options = {})
    markup = ""
    label ||= derived_label_for(curation_concern, method_name)
    subject = curation_concern.send(method_name)
    return markup if !subject.present? && !options[:include_empty]
    markup << %(<tr><th>#{label}</th>\n<td><ul class='tabular'>)
    [subject].flatten.compact.each do |value|
      markup << %(<li class="attribute #{method_name}">#{h(value)}</li>\n)
    end
    markup << %(</ul></td></tr>)
    markup.html_safe
  end

  def derived_label_for(curation_concern, method_name)
    curation_concern.respond_to?(:label_for) ? curation_concern.label_for(method_name) : method_name.to_s.humanize.titlecase
  end
  private :derived_label_for

  def classify_for_display(curation_concern)
    curation_concern.human_readable_type.downcase
  end

  def link_to_edit_permissions(curation_concern, solr_document = nil)
    markup = <<-HTML
      <a href="#{edit_polymorphic_path_for_asset(curation_concern)}" id="permission_#{curation_concern.to_param}">
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

  def polymorphic_path_args(asset)
    # A better approximation, but we still need one location for this information
    # either via routes or via the initializer of the application
    if asset.class.included_modules.include?(CurationConcern::Model)
      return [:curation_concern, asset]
    else
      return asset
    end
  end
  def polymorphic_path_for_asset(asset)
    return polymorphic_path(polymorphic_path_args(asset))
  end
  def edit_polymorphic_path_for_asset(asset)
    return edit_polymorphic_path(polymorphic_path_args(asset))
  end


  def extract_dom_label_class_and_link_title(document)
    hash = document.stringify_keys
    dom_label_class, link_title = "label-important", "Private"
    if hash[Hydra.config[:permissions][:read][:group]].present?
      if hash[Hydra.config[:permissions][:read][:group]].include?('public')
        if hash[Hydra.config[:permissions][:embargo_release_date]].present?
          dom_label_class, link_title = 'label-warning', 'Open Access with Embargo'
        else
          dom_label_class, link_title = 'label-success', 'Open Access'
        end
      elsif hash[Hydra.config[:permissions][:read][:group]].include?('registered')
        dom_label_class, link_title = "label-info", t('sufia.institution_name')
      end
    end
    return dom_label_class, link_title
  end
  private :extract_dom_label_class_and_link_title

  def auto_link_without_protocols(url)
    link = (url =~ /\A(?i)[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/) ? 'http://' + url : url
    auto_link(link, :all)
  end

end
