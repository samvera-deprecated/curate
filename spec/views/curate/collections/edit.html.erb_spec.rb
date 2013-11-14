require 'spec_helper'

describe 'curate/collections/edit.html.erb' do
  let(:collection) { FactoryGirl.build(:collection) }
  before(:each) do
    assign(:collection, collection)
    render
  end
  it 'renders page header' do
    expect(view.content_for(:page_header)).to have_tag('h1 .human_readable_type')
  end
end
