require 'spec_helper'

describe 'curation_concern/base/_contributors_attribute.html.erb' do
  let(:curation_concern) { double(contributors: [contributor]) }
  let(:contributor) { double(name: 'My Name', to_param: '123') }

  before do
    render partial: 'contributors_attribute', locals: { curation_concern: curation_concern }
  end

  it 'lists all the collections the work is added to' do
    expect(rendered).to have_tag(".tabular") do
      with_tag(".attribute.contributors") do
        with_tag("a[href$='/people/123']", text: 'My Name')
      end
    end
  end
end
