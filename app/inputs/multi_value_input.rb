class MultiValueInput < SimpleForm::Inputs::CollectionInput
  def input
    input_html_classes.unshift("string")
    input_html_options[:type] ||= 'text'
    input_html_options[:name] ||= "#{object_name}[#{attribute_name}][]"
    counter = 1
    text = "<ul class=\"multi-value listing\">\n"

    collection.each do |value|
      unless value.to_s.strip.blank?
        input_html_options[:value] = value
        input_html_options[:id] = "#{object_name}_#{attribute_name}_#{counter}"
        text << "<li class=\"field-wrapper\" data-attribute-name=\"#{object_name}_#{attribute_name}\" data-counter=\"#{counter}\">#{@builder.text_field(attribute_name, input_html_options)}</li>\n"
        counter += 1
      end
    end
    input_html_options[:value] = ''
    input_html_options[:id] = "#{object_name}_#{attribute_name}_#{counter}"
    text << "<li class=\"field-wrapper\" data-attribute-name=\"#{object_name}_#{attribute_name}\"data-counter=\"#{counter}\">#{@builder.text_field(attribute_name, input_html_options)}</li>\n"
    text << "</ul>\n"
  end

  protected
  def collection
    @collection ||= begin
      object.send(attribute_name)
    end
  end
  def multiple?; true; end
end
