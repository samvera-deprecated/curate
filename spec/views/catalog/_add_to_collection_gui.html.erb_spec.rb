require 'spec_helper'

describe 'catalog/_add_to_collection_gui' do
  let(:document) { FactoryGirl.create(:generic_work) }
  let(:person) { FactoryGirl.create(:person_with_user) }
  let(:profile) { person.profile }
  let(:profile_section) { double(title: 'Section 1', pid: '123')}

  context 'with collections' do
    before do
      assign :collection_options, [document]
      assign(:available_profiles, view.stub(:available_profiles).and_return([profile]))
      assign(:current_users_profile_sections, view.stub(:current_users_profile_sections).and_return([]))
      render partial: 'add_to_collection_gui', locals: { document: document }
    end

    it 'displays the link to add work to a collection' do
      rendered.should have_link('Add to Collection', add_member_form_collections_path(collectible_id: document.pid))
    end
  end

  context 'with a profile' do
    before do
      assign :collection_options, []
      assign(:available_profiles, view.stub(:available_profiles).and_return([profile]))
      assign(:current_users_profile_sections, view.stub(:current_users_profile_sections).and_return([profile_section]))
      render partial: 'add_to_collection_gui', locals: { document: document }
    end

    it 'displays the link to add work to a collection' do
      rendered.should have_link('Add to Collection', add_member_form_collections_path(collectible_id: document.pid))
    end
  end

  context 'with no collections and profile' do
    before do
      assign :collection_options, []
      assign(:available_profiles, view.stub(:available_profiles).and_return(nil))
      assign(:current_users_profile_sections, view.stub(:current_users_profile_sections).and_return([]))
      render partial: 'add_to_collection_gui', locals: { document: document }
    end

    it 'displays no link' do
      rendered.should_not have_link('Add to Collection')
    end
  end

end
