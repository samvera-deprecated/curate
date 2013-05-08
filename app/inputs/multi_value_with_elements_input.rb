require 'simple_form'

# Render Something Like This
#
# <div class="control-group multi_value_with_elements optional foo_bar">
#   <span class="control-label">
#     <label class="string multi_value_with_elements optional input-xlarge">Baz</label>
#     <label class="string multi_value_with_elements optional input-xlarge">Bong</label>
#   </span>
#   <div class="controls">
#     <ul class="listing">
#       <li class="field-wrapper">
#         <fieldset class="composite-input">
#           <input aria-labelledby="foo_bar_baz_label" class="foo_bar_baz multi-text-field input-xlarge" name="foo[bar][][baz]" size="30" type="text" value="baz1" />
#           <input aria-labelledby="foo_bar_bong_label" class="foo_bar_bong multi-text-field input-xlarge" name="foo[bar][][bong]" size="30" type="text" value="bong1" />
#         </fieldset>
#       </li>
#       <li class="field-wrapper">
#         <fieldset class="composite-input">
#           <input aria-labelledby="foo_bar_baz_label" class="foo_bar_baz multi-text-field input-xlarge" name="foo[bar][][baz]" size="30" type="text" value="baz2" />
#           <input aria-labelledby="foo_bar_bong_label" class="foo_bar_bong multi-text-field input-xlarge" name="foo[bar][][bong]" size="30" type="text" value="bong2" />
#         </fieldset>
#       </li>
#       <li class="field-wrapper">
#         <fieldset class="composite-input">
#           <input aria-labelledby="foo_bar_baz_label" class="foo_bar_baz multi-text-field input-xlarge" name="foo[bar][][baz]" size="30" type="text" value="" />
#           <input aria-labelledby="foo_bar_bong_label" class="foo_bar_bong multi-text-field input-xlarge" name="foo[bar][][bong]" size="30" type="text" value="" />
#         </fieldset>
#       </li>
#     </ul>
#   </div>
# </div>

class MultiValueWithElementsInput < SimpleForm::Inputs::CollectionInput
  def input
    input_html_classes.unshift("string")
    input_html_options[:type] ||= 'text'
    input_html_options[:name] ||= "#{object_name}[#{attribute_name}][]"
    markup = <<-HTML


    <ul class="listing">
    HTML

    collection.each_with_index do |value, index|
      if value.to_s.present?
        markup << field_wrapper_for(value, index)
      end
    end

    markup << field_wrapper_for('', nil)
    markup << '</ul>'
  end

  # NOTE: There is a one to many relationship between the label and the input
  # elements. Because of this we can't use the "for" attribute on the label
  # point to the "id" of the input. Instead we use the "aria-labelledby"
  # attribute on the input to point to the "id" on the label.
  #
  # It would be _better_ to use @builder construct the element but the proper
  # syntax escapes me.
  def label
    options[:elements].each_with_object('') {|element_name, html|
      html << element_label(element_name)
    }
  end

  private

  def field_wrapper_for(value, index)
    <<-HTML
    <li class="field-wrapper">
      <fieldset class="composite-input">
        #{build_text_field(value, index)}
      </fieldset>
    </li>
    HTML
  end

  def label_id(element_name)
    "#{object_name}_#{attribute_name}_#{element_name}_label"
  end

  def label_classes
    label_html_options[:class].map{|c| c.to_s}.join(' ')
  end

  def build_text_field(value, index)
    options[:elements].each_with_object('') {|element_name, html|
      html << "\n" << element_input(element_name, index)
    }
  end

  protected

  def element_input(element_name, index)
    field_name = "#{attribute_name}_#{element_name}"
    input_html_options[:name] = "#{object_name}[#{attribute_name}][][#{element_name}]"
    if index
      input_html_options[:value] = object.send(field_name)[index]
    else
      input_html_options[:value] = ''
    end
    input_html_options[:class] = "#{object_name}_#{attribute_name}_#{element_name} #{input_size} multi-text-field"
    input_html_options[:'aria-labelledby'] = label_id(element_name)
    @builder.text_field(field_name, input_html_options)
  end

  def element_label(element_name)
    attribute_label = element_name.to_s.titleize
    <<-HTML
    <label id="#{label_id(element_name)}" class="#{input_size} string #{label_classes}">#{attribute_label}</label>
    HTML
  end

  def input_size
    @input_size ||= options.fetch(:size, 'input-xlarge')
  end

  def collection
    @collection ||= begin
      object.send(attribute_name)
    end
  end
  def multiple?; true; end
end
