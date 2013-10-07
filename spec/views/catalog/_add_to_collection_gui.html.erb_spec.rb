require 'spec_helper'

describe 'catalog/_add_to_collection_gui' do
  let(:document) { FactoryGirl.create(:generic_work) }

  context 'with collections' do
    before do
      assign :collection_options, [document]
      assign :profile_collection_options, []
      render partial: 'add_to_collection_gui', locals: { document: document }
    end

    it 'displays the link to add work to a collection' do
      rendered.should have_link('Add to Collection', add_member_form_collections_path(collectible_id: document.pid))
    end
  end

  context 'with a profile' do
    before do
      assign :collection_options, []
      assign :profile_collection_options, [document]
      render partial: 'add_to_collection_gui', locals: { document: document }
    end

    it 'displays the link to add work to a collection' do
      rendered.should have_link('Add to Collection', add_member_form_collections_path(collectible_id: document.pid))
    end
  end

  context 'with no collections' do
    before do
      assign :collection_options, []
      assign :profile_collection_options, []
      render partial: 'add_to_collection_gui', locals: { document: document }
    end

    it 'displays no link' do
      rendered.should_not have_link('Add to Collection')
    end
  end

end
