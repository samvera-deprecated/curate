require 'spec_helper'
describe 'catalog/_index_partials/_thumbnail_display' do
  let(:document) { FactoryGirl.create(:generic_work, representative: '1234') }
  before do
    render partial: 'thumbnail_display', locals: { document: document }
  end
  it 'should display thumbnail' do
    rendered.should include("/downloads/1234?datastream_id=thumbnail")
  end
end
