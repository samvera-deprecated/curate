require 'simple_form'
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
            #{build_text_field(value, '')}
          </li>
        HTML
      end
    end

    markup << <<-HTML
          <li class="field-wrapper">
            #{build_text_field('', 'add')}
          </li>
        </ul>

    HTML
  end

  # NOTE: There is a one to many relationship between the label and the input
  # elements. Because of this we can't use the "for" attribute on the label
  # point to the "id" of the input. Instead we use the "aria-labelledby"
  # attribute on the input to point to the "id" on the label.
  #
  # It would be _better_ to use @builder construct the element but the proper
  # syntax escapes me.
  def label
    <<-HTML
    <label id="#{label_id}" class="string #{label_classes}">#{label_text_for(attribute_name)}</label>
    HTML
  end

  private

  def label_text_for(attribute_name)
    return options[:label] if options[:label]
    template.get_label(attribute_name)
  end

  def label_id
    "#{object_name}_#{attribute_name}_label"
  end

  def label_classes
    label_html_options[:class].map{|c| c.to_s}.join(' ')
  end

  def build_text_field(value, append_to_id)
    input_html_options[:value] = value
    input_html_options[:id] = append_to_id.blank? ? "#{attribute_name}" : "#{attribute_name}_#{append_to_id}"
    input_html_options[:class] = "#{object_name}_#{attribute_name} multi-text-field"
    input_html_options[:'aria-labelledby'] = label_id
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
