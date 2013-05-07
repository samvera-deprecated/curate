require 'simple_form/form_builder'
class CurationConcernFormBuilder < SimpleForm::FormBuilder
  def input(attribute_name, options = {}, &block)
    update_options = object.args_for_input!(attribute_name, options)
    if options[:type] == :date
      update_options[:input_html] ||= {}
      update_options[:input_html][:class] ||= ''
      update_options[:input_html][:class] << ' date datepicker'
    end
    super(attribute_name, update_options, &block)
  end
end