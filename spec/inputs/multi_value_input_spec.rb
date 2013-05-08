require 'spec_helper'

describe 'MultiValueInput' do

  class Foo
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations
    def persisted?; false; end
    attr_accessor :bar
  end

  let(:foo) { Foo.new }
  let(:bar) { ["bar1", "bar2"] }
  subject {
    foo.bar = bar
    input_for(foo, :bar,
              {
                as: :multi_value
              }
              )
  }

  describe 'happy case' do
    it 'renders multi-value' do
      expect(subject).to have_tag('.control-group.foo_bar.multi_value') do
        with_tag('.control-label') do
          with_tag('label.multi_value', text: 'Bar', for: 'foo_bar')
        end
        with_tag('.controls') do
          with_tag('ul.listing') do
            with_tag('li.field-wrapper') do
              with_tag('input.foo_bar.multi-text-field#foo_bar', name: 'foo[bar][]', value: 'bar1', multiple: 'multiple')
            end
            with_tag('li.field-wrapper') do
              with_tag('input.foo_bar.multi-text-field', name: 'foo[bar][]', value: 'bar2', multiple: 'multiple')
            end
            with_tag('li.field-wrapper') do
              with_tag('input.foo_bar.multi-text-field', name: 'foo[bar][]', value: '', multiple: 'multiple')
            end
          end
        end
      end
    end
  end
end
