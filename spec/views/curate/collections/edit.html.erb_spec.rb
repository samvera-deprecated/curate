require 'spec_helper'

describe 'curate/collections/edit.html.erb' do
  let(:collection) { FactoryGirl.build(:collection) }
  let(:work) { FactoryGirl.create(:generic_work, title: 'Title of Work') }
  before(:each) do
    collection.add_member(work)
    assign(:collection, collection)
    render
  end
  it 'renders page header' do
    expect(view.content_for(:page_header)).to have_tag('h1 .human_readable_type')
    expect(rendered).to have_content('Title of Work')
  end
end
