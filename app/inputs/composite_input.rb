require 'simple_form'

# Render Something Like This
#
# <div class="control-group composite optional foo_bar">
#   <span class="control-label">
#     <label for="foo_bar_baz" class="string composite optional input-xlarge">Baz</label>
#     <label for="foo_bar_bong" class="string composite optional input-xlarge">Bong</label>
#   </span>
#   <div class="controls">
#     <fieldset class="composite-input">
#       <input id="foo_bar_baz" class="foo_bar_baz input-xlarge" name="foo[bar][baz]" size="30" type="text" value="baz1" />
#       <input id="foo_bar_bong" class="foo_bar_bong input-xlarge" name="foo[bar][bong]" size="30" type="text" value="bong1" />
#     </fieldset>
#   </div>
# </div>

class CompositeInput < SimpleForm::Inputs::Base
  def input
    input_html_classes.unshift("string")
    input_html_options[:type] ||= 'text'
    input_html_options[:name] ||= "#{object_name}[#{attribute_name}]"
    markup = ""
    markup << field_wrapper_for('', nil)
  end

  def label
    options[:elements].each_with_object('') {|element_name, html|
      html << element_label(element_name)
    }
  end

  private

  def field_wrapper_for(value, index)
    <<-HTML
    <fieldset class="composite-input">
      #{build_text_field(value, index)}
    </fieldset>
    HTML
  end

  def label_id(element_name)
    "#{element_id(element_name)}_label"
  end

  def element_id(element_name)
    "#{object_name}_#{attribute_name}_#{element_name}"
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
    element_html_options = input_html_options.dup
    field_name = "#{attribute_name}_#{element_name}"
    element_html_options[:name] = input_html_options[:name] + "[#{element_name}]"
    if index
      element_html_options[:value] = object.send(field_name)[index]
    else
      element_html_options[:value] = ''
    end
    element_html_options[:id] = element_id(element_name)
    element_html_options[:class] = "#{object_name}_#{attribute_name}_#{element_name} #{input_size}"
    element_html_options[:'aria-labelledby'] = label_id(element_name)
    @builder.text_field(field_name, element_html_options)
  end

  def element_label(element_name)
    attribute_label = element_name.to_s.titleize
    <<-HTML
    <label id="#{label_id(element_name)}" for="#{element_id(element_name)}" class="#{input_size} string #{label_classes}">#{attribute_label}</label>
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
end
