class MultiValueInput < SimpleForm::Inputs::CollectionInput
  def input
    input_html_classes.unshift("string")
    input_html_options[:type] ||= 'text'
    input_html_options[:name] ||= "#{object_name}[#{attribute_name}][]"
    markup = <<-HTML


        <ul class="listing">
    HTML

    collection.each do |value|
      unless value.to_s.strip.blank?
        markup << <<-HTML
          <li class="field-wrapper">
            #{build_text_field(value)}
          </li>
        HTML
      end
    end

    markup << <<-HTML
          <li class="field-wrapper">
            #{build_text_field('')}
          </li>
        </ul>

    HTML
  end

  def build_text_field(value)
    input_html_options[:value] = value
    input_html_options[:id] = nil
    input_html_options[:class] = "#{object_name}_#{attribute_name}"
    input_html_options[:'aria-labelledby'] = "#{object_name}_#{attribute_name}_label"
    @builder.text_field(attribute_name, input_html_options)
  end

  protected
  def collection
    @collection ||= begin
      object.send(attribute_name)
    end
  end
  def multiple?; true; end
end
