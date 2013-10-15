require 'spec_helper'

describe 'curate/collections/show.html.erb' do
  let(:bilbo) { FactoryGirl.build(:person, name: 'Bilbo') }
  let(:frodo) { FactoryGirl.build(:person, name: 'Frodo') }
  let(:work1) { FactoryGirl.build(:generic_work, contributors: [frodo, bilbo], title: 'There and Back Again') }
  let(:coll1) { FactoryGirl.build(:collection) }

  before do
    coll1.members << work1
    assign :collection, coll1
    render
  end

  it 'lists items in the collection along with contributors' do
    assert_select '#documents ul' do
      assert_select 'a[href=?]', curation_concern_generic_work_path(work1), text: 'There and Back Again'
    end
    rendered.should have_content('Frodo')
    rendered.should have_content('Bilbo')
  end
end
