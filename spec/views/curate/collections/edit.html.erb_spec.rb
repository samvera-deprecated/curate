require 'spec_helper'

describe 'curate/collections/edit.html.erb' do
  context 'Collection' do
    let(:collection) { FactoryGirl.build(:collection) }
    before(:each) do
      assign(:collection, collection)
      render
    end
    it 'renders page header' do
      expect(view.content_for(:page_header)).to have_tag('h1 .human_readable_type')
      expect(rendered).to have_link('Cancel', href: root_path)
    end
  end

  context 'Edit Collection' do
    let(:collection) {FactoryGirl.build(:collection, title: 'Collection 1') }
    before(:each) do
      collection.save
      assign(:collection, collection)
      render
    end
    it 'should have Cancel link which takes to show view' do
      expect(rendered).to have_link('Cancel', href: collection_path(collection))
    end
  end
end
