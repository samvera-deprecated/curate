require 'spec_helper'

describe 'MultiValueWithElementsInput' do

  class Foo
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations
    def persisted?; false; end
    attr_writer :bar, :bar_baz, :bar_bong

    def bar; @bar ||= ["baz1 bong1", "baz2 bong2"]; end
    def bar_baz; @bar_baz ||= ["baz1", "baz2"]; end
    def bar_bong; @bar_bong ||= ["bong1", "bong2"]; end
  end

  subject {
    input_for(Foo.new, :bar,
      {
        elements: [:baz,:bong],
        as: :multi_value_with_elements,
        input_size: 'input-xlarge',
      }
    )
  }

  it do
    expect(subject).to have_tag('.control-group.foo_bar.multi_value_with_elements') do
      with_tag('.control-label') do
        with_tag('label.multi_value_with_elements.input-xlarge#foo_bar_baz_label', text: 'Baz')
        with_tag('label.multi_value_with_elements.input-xlarge#foo_bar_bong_label', text: 'Bong')
      end
      with_tag('.controls') do
        with_tag('ul.listing') do
          with_tag('li.field-wrapper') do
            with_tag('fieldset.composite-input') do
              with_tag('input.foo_bar_baz.input-xlarge.multi-text-field', name: 'foo[bar][][baz]', value: 'baz1')
              with_tag('input.foo_bar_baz.input-xlarge.multi-text-field', name: 'foo[bar][][bong]', value: 'bong1')
            end
          end
          with_tag('li.field-wrapper') do
            with_tag('fieldset.composite-input') do
              with_tag('input.foo_bar_baz.input-xlarge.multi-text-field', name: 'foo[bar][][baz]', value: 'baz2')
              with_tag('input.foo_bar_baz.input-xlarge.multi-text-field', name: 'foo[bar][][bong]', value: 'bong2')
            end
          end
          with_tag('li.field-wrapper') do
            with_tag('fieldset.composite-input') do
              with_tag('input.foo_bar_baz.input-xlarge.multi-text-field', name: 'foo[bar][][baz]', value: '')
              with_tag('input.foo_bar_baz.input-xlarge.multi-text-field', name: 'foo[bar][][bong]', value: '')
            end
          end
        end
      end
    end
  end
end
