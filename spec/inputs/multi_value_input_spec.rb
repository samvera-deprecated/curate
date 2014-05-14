require 'spec_helper'

describe 'MultiValueInput' do

  class Foo
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations
    def persisted?; false; end
    attr_accessor :bar
  end

  context 'happy case' do
    let(:foo) { Foo.new }
    let(:bar) { ["bar1", "bar2"] }
    subject do
      foo.bar = bar
      input_for(foo, :bar, { as: :multi_value, required: true } )
    end

    it 'renders multi-value' do
      expect(subject).to have_tag('.control-group.foo_bar.multi_value') do
        with_tag('.control-label') do
          with_tag('label.multi_value.required', text: '* Bar', with: {for: 'foo_bar'}) do
            with_tag("abbr")
          end
        end
        with_tag('.controls') do
          with_tag('ul.listing') do
            with_tag('li.field-wrapper') do
              with_tag('input.foo_bar.required.multi-text-field#foo_bar', with: {name: 'foo[bar][]', value: 'bar1', required: 'required'})
            end
            with_tag('li.field-wrapper') do
              with_tag('input.foo_bar.multi-text-field', with: {name: 'foo[bar][]', value: 'bar2'}, without: {required: 'required'})
            end
            with_tag('li.field-wrapper') do
              with_tag('input.foo_bar.multi-text-field', with: {name: 'foo[bar][]', value: ''}, without: {required: 'required'})
            end
          end
        end
      end
    end
  end

  context 'unhappy case' do
    let(:foo) { Foo.new }
    let(:bar) { nil }
    subject do
      foo.bar = bar
      input_for(foo, :bar, { as: :multi_value, required: true } )
    end

    it 'renders multi-value given a nil object' do
      expect(subject).to have_tag('.control-group.foo_bar.multi_value') do
        with_tag('.control-label') do
          with_tag('label.multi_value.required', text: '* Bar', with: {for: 'foo_bar'}) do
            with_tag("abbr")
          end
        end
        with_tag('.controls') do
          with_tag('ul.listing') do
            with_tag('li.field-wrapper') do
              with_tag('input.foo_bar.required.multi-text-field#foo_bar', with: {name: 'foo[bar][]', value: '', required: 'required'})
            end
          end
        end
      end
    end
  end
end
