require 'spec_helper'
describe AccordionBuilderHelper, type: :helper do
  let(:pane) { Struct.new(:title, :content) }
  let(:first_pane) { pane.new('Hello World', 'Good-Bye')}
  let(:second_pane) { pane.new('Something', 'Different')}
  it 'renders' do
    rendered = accordion do |set|
      set.pane(first_pane.title, open_next: 'true') do
        first_pane.content
      end +
      set.pane(second_pane.title) do
        second_pane.content
      end
    end

    expect(rendered).to have_tag('#accordion.accordion') do
      with_tag('.accordion-group') do
        with_tag('.accordion-heading a[href="#accordion-fieldset-0"]', text: first_pane.title)
        with_tag('.accordion-body.collapse.in#accordion-fieldset-0') do
          with_tag('.accordion-inner') do
            with_tag('div', text: first_pane.content)
            with_tag('.row a.continue[href="#accordion-fieldset-1"]')
          end
        end
        with_tag('.accordion-heading a[href="#accordion-fieldset-1"]', text: second_pane.title)
        with_tag('.accordion-body.collapse.in#accordion-fieldset-1') do
          with_tag('.accordion-inner') do
            with_tag('div', text: second_pane.content)
          end
        end
      end
    end
  end
end
