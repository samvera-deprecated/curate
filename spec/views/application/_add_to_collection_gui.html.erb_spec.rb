require 'spec_helper'

describe 'application/add_to_collection_gui' do
  let(:document)        { double(title: 'A Document',        pid: 'sufia:vwxyz', noid: 'vwxyz') }
  let(:profile)         { double(title: 'Your Profile',      pid: 'sufia:abcde', noid: 'abcde') }
  let(:collection)      { double(title: 'A Collection',      pid: 'sufia:12345', noid: '12345') }
  let(:profile_section) { double(title: 'A Profile Section', pid: 'sufia:56789', noid: '56789') }

  context 'with collections and no profile sections' do
    before do
      view.stub(:current_users_profile_sections).and_return([])
      view.stub(:available_collections).and_return([collection])
      view.stub(:available_profiles).and_return([])

      render partial: 'add_to_collection_gui', locals: { collectible: document }
    end

    it 'displays add link; lists collection as an option' do
      expect(rendered).to include('Your Collections')
      expect(rendered).to include(collection.pid)
      expect(rendered).to_not include('Profile Sections')
      expect(rendered).to have_link('Add to Collection', add_member_form_collections_path(collectible_id: document.pid))
    end
  end

  context 'with a profile and profile section' do
    before do
      view.stub(:current_users_profile_sections).and_return([profile_section])
      view.stub(:available_collections).and_return([])
      view.stub(:available_profiles).and_return([profile])

      render partial: 'add_to_collection_gui', locals: { collectible: document }
    end

    it 'displays add link; lists profile section as an option' do
      expect(rendered).to_not include('Your Collections')
      expect(rendered).to include(profile.pid)
      expect(rendered).to include('Profile Sections')
      expect(rendered).to include(profile_section.pid)
      expect(rendered).to have_link('Add to Collection', add_member_form_collections_path(collectible_id: document.pid))
    end
  end

  context 'with no collections and no profile' do
    before do
      view.stub(:current_users_profile_sections).and_return([])
      view.stub(:available_collections).and_return([])
      view.stub(:available_profiles).and_return([])

      render partial: 'add_to_collection_gui', locals: { collectible: document }
    end

    it 'displays add link; includes no profile or collections' do
      expect(rendered).to_not include('Your Collections')
      expect(rendered).to_not include('Profile Sections')
      expect(rendered).to have_link('Add to Collection', add_member_form_collections_path(collectible_id: document.pid))
    end
  end
end

