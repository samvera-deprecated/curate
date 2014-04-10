require 'spec_helper'

describe 'curation_concern/base/_contributors_attribute.html.erb' do
  let(:curation_concern) { double(contributor: [contributor]) }
  let(:contributor) { 'My Name' }

  before do
    render partial: 'contributors_attribute', locals: { curation_concern: curation_concern }
  end

  it 'lists all the collections the work is added to' do
    expect(rendered).to have_tag(".tabular") do
      with_tag(".attribute.contributors", text: contributor)
    end
  end
end
