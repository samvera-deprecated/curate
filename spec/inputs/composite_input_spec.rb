require 'spec_helper'

describe 'CompositeInput' do

  class Foo
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations
    def persisted?; false; end
    attr_writer :bar, :bar_baz, :bar_bong

    def bar; @bar ||= "baz1 bong1"; end
    def bar_baz; @bar_baz ||= "baz1"; end
    def bar_bong; @bar_bong ||= "bong1"; end
  end

  subject {
    input_for(
      Foo.new, :bar,
      {
        elements: [:baz,:bong],
        as: :composite,
        input_size: 'input-xlarge',
      }
    )
  }

  it do
    expect(subject).to have_tag('.control-group.foo_bar.composite') do
      with_tag('.control-label') do
        with_tag('label.composite.input-xlarge#foo_bar_baz_label', text: 'Baz', for: 'foo_bar_baz')
        with_tag('label.composite.input-xlarge#foo_bar_bong_label', text: 'Bong', for: 'foo_bar_bong')
      end
      with_tag('.controls') do
        with_tag('fieldset.composite-input') do
          with_tag('input.foo_bar_baz.input-xlarge#foo_bar_baz', name: 'foo[bar][baz]', value: 'baz1')
          with_tag('input.foo_bar_baz.input-xlarge#foo_bar_baz', name: 'foo[bar][bong]', value: 'bong1')
        end
      end
    end
  end
end
